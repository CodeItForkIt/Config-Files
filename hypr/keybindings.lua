-- ============================================================
--  keybindings.lua  —  Hyprland 0.55+ Lua
--  Confirmed from official wiki docs:
--    hl.bind("KEYS", hl.dsp.exec_cmd("cmd"))
--    hl.bind("KEYS", hl.dsp.exec_cmd("cmd"), opts)
--    hl.bind("KEYS", function() ... end)
--    hl.dsp.focus({ workspace = "3" })       — workspace switch
--    hl.dsp.focus({ direction = "l" })       — window focus direction
--    hl.dsp.window.move({ workspace = "3" })     — movetoworkspace (window → workspace)
--    window.move is the movetoworkspace dispatcher
--    silent movetoworkspace = separate: hl.dsp.exec_cmd("[workspace N silent] ...")
--    hl.dsp.window.drag()                    — mouse drag, no args
--    hl.dsp.window.resize()                  — mouse resize, no args
--    hl.dsp.layout("togglesplit")            — plain string
--    hl.dsp.window.float({ action = "toggle" })
--    hl.dsp.window.fullscreen()
--    hl.dsp.window.cycle_next()
--    hl.dsp.workspace.toggle_special()
--    hl.dsp.exit()
--    mouse binds use { mouse = true }
-- ============================================================
local hyprspace = require("edit_here.Hyprspace.Hyprspace")
local home = os.getenv("HOME")
local scrPath = home .. "/.local/lib/hyde"

local TERMINAL = "kitty"
local EDITOR = "nvim"
local EXPLORER = "nautilus"
local BROWSER = "vivaldi"

-- ============================================================
--  WINDOW MANAGEMENT
-- ============================================================
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SHIFT + Tab", function()
	hyprspace.toggle()
end)
hl.bind("SUPER + Q", hl.dsp.exec_cmd(scrPath .. "/dontkillsteam.sh"), { desc = "close focused window" })
hl.bind("ALT + F4", hl.dsp.exec_cmd(scrPath .. "/dontkillsteam.sh"), { desc = "close focused window" })
hl.bind("SUPER + Delete", hl.dsp.exit(), { desc = "kill hyprland session" })
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd(scrPath .. "~/HyprLand/sendtoggle"))
hl.bind("SUPER + W", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch resizeactive exact 95% 95%"))
	hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch centerwindow"))
end, { desc = "toggle floating" })

hl.bind("SHIFT + F11", hl.dsp.window.fullscreen(), { desc = "toggle fullscreen" })
hl.bind(
	"SUPER + L",
	hl.dsp.exec_cmd("bash -c '~/.config/hypr/quotes/update_quote.sh && hyprlock'"),
	{ desc = "lock screen" }
)
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(scrPath .. "/windowpin.sh"), { desc = "toggle pin" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(scrPath .. "/logoutlaunch.sh"), { desc = "logout menu" })
hl.bind("SUPER + H", hl.dsp.exec_cmd("bash -c '~/scripts/keybindings.sh'"), { desc = "show keybinds" })
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"), { desc = "toggle split" })
hl.bind("SUPER+Q", function()
	hl.dispatch(hl.dsp.window.close())
end)

-- Group navigation
hl.bind("SUPER + CTRL + H", hl.dsp.group.prev(), { desc = "prev group tab" })
hl.bind("SUPER + CTRL + L", hl.dsp.group.next(), { desc = "next group tab" })

-- Directional focus
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "l" }), { desc = "focus left" })
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "r" }), { desc = "focus right" })
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "u" }), { desc = "focus up" })
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "d" }), { desc = "focus down" })
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { desc = "cycle focus" })
-- Resize (repeating)
-- Resize (repeating)

-- Resize (repeating)
-- Resize (repeating)
local maw = 'grep -q "true" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive'
hl.bind(
	"SUPER + SHIFT + CTRL + left",
	hl.dsp.exec_cmd(maw .. " -30 0 || hyprctl dispatch movewindow l"),
	{ repeating = true, desc = "move window left" }
)
hl.bind(
	"SUPER + SHIFT + CTRL + right",
	hl.dsp.exec_cmd(maw .. " 30 0 || hyprctl dispatch movewindow r"),
	{ repeating = true, desc = "move window right" }
)
hl.bind(
	"SUPER + SHIFT + CTRL + up",
	hl.dsp.exec_cmd(maw .. " 0 -30 || hyprctl dispatch movewindow u"),
	{ repeating = true, desc = "move window up" }
)
hl.bind(
	"SUPER + SHIFT + CTRL + down",
	hl.dsp.exec_cmd(maw .. " 0 30 || hyprctl dispatch movewindow d"),
	{ repeating = true, desc = "move window down" }
)

-- Mouse move/resize
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, desc = "drag to move" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, desc = "drag to resize" })
hl.bind("SUPER + Z", hl.dsp.window.drag(), { mouse = true, desc = "drag to move" })
hl.bind("SUPER + X", hl.dsp.window.resize(), { mouse = true, desc = "drag to resize" })

-- ============================================================
--  LAUNCHERS
-- ============================================================

hl.bind("SUPER + T", hl.dsp.exec_cmd(TERMINAL), { desc = "terminal" })
hl.bind(
	"SUPER + ALT + T",
	hl.dsp.exec_cmd("[float; move 20% 5%; size 60% 60%] " .. TERMINAL),
	{ desc = "dropdown terminal" }
)
hl.bind("SUPER + E", hl.dsp.exec_cmd(EXPLORER), { desc = "file explorer" })
hl.bind("SUPER + C", hl.dsp.exec_cmd(EDITOR), { desc = "text editor" })
hl.bind("SUPER + B", hl.dsp.exec_cmd(BROWSER), { desc = "web browser" })
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(scrPath .. "/sysmonlaunch.sh"), { desc = "system monitor" })
hl.bind("SUPER + D", hl.dsp.exec_cmd("discord"), { desc = "discord" })
hl.bind("SUPER + R", hl.dsp.exec_cmd("steam"), { desc = "steam" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("thunderbird"), { desc = "thunderbird" })
hl.bind("SUPER + A", hl.dsp.exec_cmd("spotify"), { desc = "spotify" })

-- ============================================================
--  HARDWARE CONTROLS
-- ============================================================

hl.bind("F10", hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o m"), { locked = true, desc = "toggle mute" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o m"), {
	locked = true,
	desc = "toggle mute",
})
hl.bind(
	"F11",
	hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o d"),
	{ locked = true, repeating = true, desc = "decrease volume" }
)
hl.bind(
	"F12",
	hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o i"),
	{ locked = true, repeating = true, desc = "increase volume" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -i m"),
	{ locked = true, desc = "mute microphone" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o d"),
	{ locked = true, repeating = true, desc = "decrease volume" }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o i"),
	{ locked = true, repeating = true, desc = "increase volume" }
)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, desc = "play/pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, desc = "pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, desc = "next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, desc = "prev track" })
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(scrPath .. "/brightnesscontrol.sh i"),
	{ repeating = true, desc = "brightness up" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(scrPath .. "/brightnesscontrol.sh d"),
	{ repeating = true, desc = "brightness down" }
)

-- ============================================================
--  UTILITIES
-- ============================================================

hl.bind(
	"SUPER + K",
	hl.dsp.exec_cmd(scrPath .. "/keyboardswitch.sh"),
	{ locked = true, desc = "switch keyboard layout" }
)
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -an"), { desc = "color picker" })
hl.bind("SUPER + P", hl.dsp.exec_cmd(scrPath .. "/screenshot.sh s"), { desc = "snip screen" })
hl.bind("SUPER + CTRL + P", hl.dsp.exec_cmd(scrPath .. "/screenshot.sh sf"), { desc = "freeze snip" })
hl.bind(
	"SUPER + ALT + P",
	hl.dsp.exec_cmd(scrPath .. "/screenshot.sh m"),
	{ locked = true, desc = "screenshot monitor" }
)
hl.bind("Print", hl.dsp.exec_cmd(scrPath .. "/screenshot.sh p"), { locked = true, desc = "screenshot all" })

-- ============================================================
--  THEMING / WALLPAPER
-- ============================================================

hl.bind("SUPER + ALT + Right", hl.dsp.exec_cmd(scrPath .. "/wallpaper.sh -Gn"), { desc = "next wallpaper" })
hl.bind("SUPER + ALT + Left", hl.dsp.exec_cmd(scrPath .. "/wallpaper.sh -Gp"), { desc = "previous wallpaper" })
hl.bind(
	"SUPER + SHIFT + W",
	hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/wallpaper.sh -SG"),
	{ desc = "select wallpaper" }
)
hl.bind("SUPER + ALT + Up", hl.dsp.exec_cmd(scrPath .. "/wbarconfgen.sh n"), { desc = "next bar layout" })
hl.bind("SUPER + ALT + Down", hl.dsp.exec_cmd(scrPath .. "/wbarconfgen.sh p"), { desc = "prev bar layout" })
hl.bind(
	"SUPER + SHIFT + R",
	hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/wallbashtoggle.sh -m"),
	{ desc = "wallbash mode" }
)
hl.bind(
	"SUPER + SHIFT + T",
	hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/themeselect.sh"),
	{ desc = "select theme" }
)
hl.bind(
	"SUPER + SHIFT + Y",
	hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/animations.sh --select"),
	{ desc = "select animations" }
)
hl.bind(
	"SUPER + SHIFT + U",
	hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/hyprlock.sh --select"),
	{ desc = "select hyprlock" }
)

-- ============================================================
--  WORKSPACES
--  window.move({ workspace }) — movetoworkspace dispatcher
--  silent move — use exec_cmd with dispatch rule prefix "[workspace N silent]"
--  focus({ workspace }) — switch workspace on current monitor
-- ============================================================

for i = 1, 10 do
	local key = tostring(i % 10)
	local ws = tostring(i)

	-- Switch to workspace
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = ws }), { desc = "workspace " .. ws })

	-- Move active window to workspace (focus follows)
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }), { desc = "move to workspace " .. ws })

	-- Move active window to workspace silently (no focus follow)
	-- silent is not a table field — use exec dispatch rule prefix
	hl.bind(
		"SUPER + ALT + " .. key,
		hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. ws),
		{ desc = "move to workspace " .. ws .. " silent" }
	)
end

-- Relative workspace navigation
hl.bind("SUPER + CTRL + Right", hl.dsp.focus({ workspace = "r+1" }), { desc = "next workspace" })
hl.bind("SUPER + CTRL + Left", hl.dsp.focus({ workspace = "r-1" }), { desc = "prev workspace" })
hl.bind("SUPER + CTRL + Down", hl.dsp.focus({ workspace = "empty" }), { desc = "empty workspace" })
hl.bind("SUPER + CTRL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }), { desc = "move window forward" })
hl.bind("SUPER + CTRL + ALT + Left", hl.dsp.window.move({ workspace = "r-1" }), { desc = "move window back" })

-- Mouse scroll workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "scroll workspace fwd" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { desc = "scroll workspace bck" })

-- Special / scratchpad
hl.bind("SUPER + G", hl.dsp.workspace.toggle_special(), { desc = "toggle scratchpad" })

hl.bind("SUPER + SHIFT + G", hl.dsp.window.move({ workspace = "special" }), { desc = "move to scratchpad" })

hl.bind(
	"SUPER + ALT + G",
	hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent special"),
	{ desc = "move to scratchpad silent" }
)

hl.bind(
	"SUPER + SHIFT + grave",
	hl.dsp.window.move({ workspace = "special:games" }),
	{ desc = "move to games workspace" }
)
