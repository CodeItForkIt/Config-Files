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
local home = os.getenv("HOME")
local scrPath = home .. "/.local/lib/hyde"

local TERMINAL = "kitty"
local EDITOR = "kitty nvim"
local EXPLORER = "nemo"
local BROWSER = "vivaldi"
local mainMod = "SUPER"
local ipc = "noctalia msg "

-- Core binds
hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. "+S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind("SUPER + TAB", function()
	hl.plugin.hyprtasking.toggle("cursor")
end)

-- escape closes the overview if it's open
-- hl.bind("escape", function()
--	if hl.plugin.hyprtasking.is_active() then
--		hl.plugin.hyprtasking.toggle("all")
--	end
-- end, { non_consuming = true })

hl.bind("SUPER + X", function()
	hl.plugin.hyprtasking.killhovered()
end)

hl.bind("SUPER + H", function()
	hl.plugin.hyprtasking.move("left")
end)
hl.bind("SUPER + J", function()
	hl.plugin.hyprtasking.move("down")
end)
hl.bind("SUPER + K", function()
	hl.plugin.hyprtasking.move("up")
end)
hl.bind("SUPER + L", function()
	hl.plugin.hyprtasking.move("right")
end)

hl.bind("SUPER + A", function()
	hl.plugin.hyprtasking.move("out")
end)
hl.bind("SUPER + SHIFT + A", function()
	hl.plugin.hyprtasking.movewindow("out")
end)

hl.bind("SUPER + CTRL + 1", function()
	hl.plugin.hyprtasking.setlayer(1)
end)
hl.bind("SUPER + CTRL + 2", function()
	hl.plugin.hyprtasking.setlayer(2)
end)
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen"))
hl.config({
	plugin = {
		hyprtasking = {
			layout = "linear",

			gap_size = 5,
			border_size = 1,
			bg_color = 0x00000000,
			exit_on_hovered = false,
			warp_on_move_window = 1,
			close_overview_on_reload = false,

			-- for other mouse buttons see <linux/input-event-codes.h>
			drag_button = 0x111, -- left mouse button
			select_button = 0x110, -- right mouse button

			jump = {
				enabled = false,
				label_color = 0xffffffff,
				label_background = 0x000000cc,
				label_size = 32,
			},

			gestures = {
				enabled = true,
				move_fingers = 3,
				move_distance = 300,
				open_fingers = 4,
				open_distance = 300,
				open_positive = true,
			},

			grid = {
				rows = 3,
				cols = 3,
				loop = false,
				layers = 2,
				loop_layers = true,
				gaps_use_aspect_ratio = true,
			},

			linear = {
				top = true,
				height = 400,
				scroll_speed = 1.0,
				blur = true,
			},
		},
	},
})

-- Noctalia Settings
hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})
-- ============================================================
--  WINDOW MANAGEMENT
-- ============================================================
hl.bind("SUPER + X", function()
	if hl.get_workspace("special:minimized") then
		hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
		hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
	else
		hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
		hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
	end
end)
hl.bind("SUPER + Q", hl.dsp.exec_cmd(scrPath .. "/dontkillsteam.sh"), { desc = "close focused window" })
hl.bind("ALT + F4", hl.dsp.exec_cmd(scrPath .. "/dontkillsteam.sh"), { desc = "close focused window" })
hl.bind("SUPER + W", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch resizeactive exact 95% 95%"))
	hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch centerwindow"))
end, { desc = "toggle floating" })

hl.bind("SHIFT + F11", hl.dsp.window.fullscreen(), { desc = "toggle fullscreen" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(scrPath .. "/windowpin.sh"), { desc = "toggle pin" })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(scrPath .. "/logoutlaunch.sh"), { desc = "logout menu" })
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd("bash -c '~/scripts/keybindings.sh'"), { desc = "show keybinds" })
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
	"SUPER + ALT + D",
	hl.dsp.exec_cmd("/usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh record"),
	{ desc = "Hyprwhspr enable" }
)
hl.bind(
	"SUPER + ALT + A",
	hl.dsp.exec_cmd(home .. "/.local/bin/hyprwhspr-assistant.sh"),
	{ desc = "Voice assistant (commands + local chat)" }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(scrPath .. "/volumecontrol.sh -o i"),
	{ locked = true, repeating = true, desc = "increase volume" }
)
hl.bind("F8", hl.dsp.exec_cmd("playerctl play-pause"))
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

	hl.bind(
		"SUPER + " .. key,
		hl.dsp.focus({ workspace = ws, on_current_monitor = true }),
		{ desc = "workspace " .. ws .. " (current monitor)" }
	)

	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }), { desc = "move to workspace " .. ws })

	hl.bind(
		"SUPER + ALT + " .. key,
		hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.window.move({ workspace = \"" .. ws .. "\", follow = false })'"),
		{ desc = "move to workspace " .. ws .. " silent" }
	)
end
-- Relative workspace navigation
hl.bind(
	"SUPER + mouse_down",
	hl.dsp.focus({ workspace = "e-1", on_current_monitor = true }),
	{ desc = "scroll workspace fwd" }
)
hl.bind(
	"SUPER + mouse_up",
	hl.dsp.focus({ workspace = "e+1", on_current_monitor = true }),
	{ desc = "scroll workspace bck" }
)
hl.bind(
	"SUPER + CTRL + Right",
	hl.dsp.focus({ workspace = "r+1", on_current_monitor = true }),
	{ desc = "next workspace" }
)
hl.bind(
	"SUPER + CTRL + Left",
	hl.dsp.focus({ workspace = "r-1", on_current_monitor = true }),
	{ desc = "prev workspace" }
) -- Special / scratchpad
hl.bind("SUPER + G", hl.dsp.workspace.toggle_special( Games ), { desc = "toggle scratchpad" }),
hl.bind("SUPER + G", hl.dsp.move({ workspace = special:Games, follow = true, })),
hl.bind(
	"SUPER + ALT + G",
	hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent special"),
	{ desc = "move to scratchpad silent" }
)

hl.bind(
	"SUPER + SHIFT + grave",
	hl.dsp.window.move({ workspace = "special:Games" }),
	{ desc = "move to games workspace" }
)
