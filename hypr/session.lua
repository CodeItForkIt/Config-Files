-- session.lua — save/restore open windows across Hyprland restarts, entirely
-- via native Lua dispatch (hl.get_windows/hl.exec_cmd/hl.dispatch), no
-- external hyprctl/jq subprocess. Hooked into hl.on("hyprland.start"/
-- "hyprland.shutdown") below; keybindings.lua binds a manual save key to
-- require("session").save().
local home = os.getenv("HOME")
local xdgState = os.getenv("XDG_STATE_HOME") or (home .. "/.local/state")
local STATE_FILE = xdgState .. "/hypr/session.lua"

-- Class -> relaunch command overrides, for classes where reading
-- /proc/<pid>/cmdline (the fallback below) resolves to something that won't
-- actually relaunch the app correctly — e.g. a flatpak/snap/JVM app whose
-- real launch command isn't visible from outside its sandbox. Use "SKIP" to
-- never save/restore a class at all (panel overlays, launchers, etc).
-- Example: ["Spotify"] = "flatpak run com.spotify.Client"
local APP_OVERRIDES = {}

local function shell_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- Best-effort relaunch command from the process's own argv. Fails for
-- sandboxed apps (flatpak/snap/appimage) whose real command isn't visible
-- from outside the sandbox — add an APP_OVERRIDES entry for those.
local function cmdline_for_pid(pid)
	local f = io.open("/proc/" .. pid .. "/cmdline", "rb")
	if not f then
		return nil
	end
	local data = f:read("*a")
	f:close()
	if not data or data == "" then
		return nil
	end
	local args, start = {}, 1
	while true do
		local nul_pos = data:find("\0", start, true)
		local part = nul_pos and data:sub(start, nul_pos - 1) or data:sub(start)
		if part ~= "" then
			table.insert(args, shell_quote(part))
		end
		if not nul_pos then
			break
		end
		start = nul_pos + 1
	end
	if #args == 0 then
		return nil
	end
	return table.concat(args, " ")
end

local function resolve_launch_cmd(class, pid)
	local override = APP_OVERRIDES[class]
	if override then
		return override
	end
	return cmdline_for_pid(pid) or class:lower()
end

-- win.at/win.size come back as either {x=,y=} or {1,2}-style tables
-- depending on Hyprland version; handle both.
local function vec2(v)
	if type(v) ~= "table" then
		return 0, 0
	end
	if v.x ~= nil and v.y ~= nil then
		return v.x, v.y
	end
	return v[1] or 0, v[2] or 0
end

local function class_of(win)
	if win.initial_class and win.initial_class ~= "" then
		return win.initial_class
	end
	return win.class
end

local function serialize_entries(entries)
	local lines = { "return {" }
	for _, e in ipairs(entries) do
		table.insert(
			lines,
			string.format(
				"\t{ class = %q, cmd = %q, workspace = %d, floating = %s, fullscreen = %s, at = { %d, %d }, size = { %d, %d } },",
				e.class,
				e.cmd,
				e.workspace,
				tostring(e.floating),
				tostring(e.fullscreen),
				e.at_x,
				e.at_y,
				e.size_w,
				e.size_h
			)
		)
	end
	table.insert(lines, "}\n")
	return table.concat(lines, "\n")
end

local function session_save()
	local entries = {}
	for _, win in ipairs(hl.get_windows({})) do
		if win.mapped then
			local class = class_of(win)
			local cmd = resolve_launch_cmd(class, win.pid)
			if cmd ~= "SKIP" then
				local at_x, at_y = vec2(win.at)
				local size_w, size_h = vec2(win.size)
				table.insert(entries, {
					class = class,
					cmd = cmd,
					workspace = win.workspace and win.workspace.id or 1,
					floating = win.floating,
					fullscreen = (win.fullscreen or 0) ~= 0,
					at_x = at_x,
					at_y = at_y,
					size_w = size_w,
					size_h = size_h,
				})
			end
		end
	end

	os.execute("mkdir -p " .. shell_quote(STATE_FILE:match("(.*)/")))
	local f = io.open(STATE_FILE, "w")
	if f then
		f:write(serialize_entries(entries))
		f:close()
	end
end

local function count_open_by_class()
	local counts = {}
	for _, win in ipairs(hl.get_windows({})) do
		if win.mapped then
			local class = class_of(win)
			counts[class] = (counts[class] or 0) + 1
		end
	end
	return counts
end

-- Classes we're waiting to see (re)open so we can fullscreen the specific
-- new window, rather than guessing via a class-matching selector. Cleared
-- after a grace period so an unrelated window opened much later never gets
-- force-fullscreened by a stale pending entry (e.g. an app that failed to
-- launch during restore).
local pending_fullscreen = {}

hl.on("window.open", function(win)
	local class = class_of(win)
	if (pending_fullscreen[class] or 0) > 0 then
		pending_fullscreen[class] = pending_fullscreen[class] - 1
		-- Best-effort: window.fullscreen() toggles, and its exact accepted
		-- params for a non-active target window are unverified against a
		-- live compositor — check this actually fullscreens the restored
		-- window and doesn't just no-op.
		hl.dispatch(hl.dsp.window.fullscreen({ window = win }))
	end
end)

local function session_restore()
	local ok, entries = pcall(dofile, STATE_FILE)
	if not ok or type(entries) ~= "table" then
		return
	end

	local open_counts = count_open_by_class()

	for _, e in ipairs(entries) do
		local already = open_counts[e.class] or 0
		if already > 0 then
			open_counts[e.class] = already - 1
		else
			local rules = "workspace " .. e.workspace .. " silent"
			if e.floating then
				rules = rules
					.. ";float;move "
					.. e.at[1]
					.. " "
					.. e.at[2]
					.. ";size "
					.. e.size[1]
					.. " "
					.. e.size[2]
			end
			-- hl.exec_cmd(cmd, rules?) takes rules as a separate table and
			-- likely doesn't parse a bracket-prefix out of cmd itself; the
			-- bracket-rule string form is only confirmed working through
			-- hl.dsp.exec_cmd (see keybindings.lua's TERMINAL float bind),
			-- fired immediately here via hl.dispatch.
			hl.dispatch(hl.dsp.exec_cmd("[" .. rules .. "] " .. e.cmd))
			if e.fullscreen then
				pending_fullscreen[e.class] = (pending_fullscreen[e.class] or 0) + 1
			end
		end
	end

	hl.timer(function()
		pending_fullscreen = {}
	end, { timeout = 15000, type = "oneshot" })
end

-- Triggered from hyprland.lua's existing hl.on("hyprland.start", ...) block
-- (restore) and Noctalia's [hooks] via `hyprctl dispatch` (save) — see there.
return {
	save = session_save,
	restore = session_restore,
}
