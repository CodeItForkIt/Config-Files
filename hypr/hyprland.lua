-- ============================================================
--  hyprland.lua  —  Hyprland 0.55+ Lua config
-- ============================================================
require("monitors")
require("animations")
require("windowrules")
require("keybindings")
require("userprefs")
require("plugins")
require("hyprland-gui")
-- require("plugins")
require("scrolling-niri") -- native Niri-style scrolling layout
-- ============================================================
--  VARIABLES
-- ============================================================
local home = os.getenv("HOME")
local scrPath = home .. "/.local/lib/hyde"
local FONT = "Times New Roman"

local xdgConfig = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local xdgCache = os.getenv("XDG_CACHE_HOME") or (home .. "/.cache")
local xdgData = os.getenv("XDG_DATA_HOME") or (home .. "/.local/share")
local xdgState = os.getenv("XDG_STATE_HOME") or (home .. "/.local/state")
local xdgRuntime = os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000"

-- ============================================================
--  ENVIRONMENT VARIABLES
-- ============================================================
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("XDG_CONFIG_HOME", xdgConfig)
hl.env("XDG_CACHE_HOME", xdgCache)
hl.env("XDG_DATA_HOME", xdgData)
hl.env("XDG_STATE_HOME", xdgState)
hl.env("XDG_RUNTIME_DIR", xdgRuntime)
hl.env("HYDE_RUNTIME_DIR", xdgRuntime .. "/hyde")
hl.env("HYDE_CONFIG_HOME", xdgConfig .. "/hyde")
hl.env("HYDE_CACHE_HOME", xdgCache .. "/hyde")
hl.env("HYDE_DATA_HOME", xdgData .. "/hyde")
hl.env("HYDE_STATE_HOME", xdgState .. "/hyde")
hl.env("PATH", home .. "/.local/bin:" .. scrPath .. ":" .. (os.getenv("PATH") or ""))
hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("TERMINAL", "kitty")
--hl.env("WLR_DRM_NO_MODIFIERS", "1")
-- ============================================================
--  CORE CONFIGURATION
-- ============================================================
-- Noctalia Settings
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 0,
	},
	hl.env("AQ_DRM_DEVICES", "/dev/dri/amd-dgpu"),
	decoration = {
		rounding = 20,
		rounding_power = 2,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})

hl.config({
	general = {
		snap = { enabled = true },
	},

	decoration = {
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		fullscreen_opacity = 1.0,
		blur = {
			special = true,
		},
	},

	hl.device({
		name = "HUGE-trackball",
		accel_profile = "custom 0.2144477506 0.000 0.307 0.615 1.077 1.539 2.002 2.505 3.208 3.910 4.613 5.315 6.018 6.720 7.423 8.125 8.828 9.530 10.233 10.935 12.387",
	}),

	input = {
		accel_profile = "adaptive",
		numlock_by_default = true,
		focus_on_close = 1,
		touchpad = {
			natural_scroll = false,
		},
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		vrr = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		animate_manual_resizes = true,
		animate_mouse_windowdragging = true,
		font_family = FONT,
		enable_swallow = true,
		focus_on_activate = true,
	},

	xwayland = {
		force_zero_scaling = true,
		use_nearest_neighbor = false,
	},

	group = {
		groupbar = {
			enabled = true,
			gradients = true,
			render_titles = true,
			font_size = 12,
			font_family = FONT,
		},
	},
})
hl.config({ cursor = { no_hardware_cursors = true } })
-- ============================================================
--  EXEC-ONCE  (hyprland.start fires exactly once at startup)
-- ============================================================

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- " .. scrPath .. "/resetxdgportal.sh || " .. scrPath .. "/resetxdgportal.sh")
	hl.exec_cmd(
		"uwsm app -- dbus-update-activation-environment --systemd --all || dbus-update-activation-environment --systemd --all"
	)
	hl.exec_cmd(
		"uwsm app -- systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP || systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
	)
	hl.exec_cmd("uwsm app -t service -s a -- blueman-applet || blueman-applet")
	hl.exec_cmd("uwsm app -t service -s s -- wl-paste --type text --watch cliphist store")
	hl.exec_cmd("uwsm app -t service -s s -- wl-paste --type image --watch cliphist store")
	hl.exec_cmd("uwsm app -t service -s s -- wl-clip-persist --clipboard regular")
	hl.exec_cmd("uwsm app -t service -s a -- udiskie --no-automount --smart-tray")
	hl.exec_cmd("hyprpm reload")
	hl.exec_cmd("hyprctl setcursor Nordzy-hyprcursors-catppuccin-frappe-dark 23")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("sudo systemctl restart systemd-resolved")
	-- Workspace startup apps — dispatch rule prefix syntax confirmed from wiki
	hl.exec_cmd("uwsm app -t service -s b -- ~/.config/scripts/cfg-watch.sh")
	hl.exec_cmd("uwsm app -t service -s a -- noctalia || noctalia")
	hl.exec_cmd(
		"uwsm app -t service -s b -- ~/.config/hypr/workspace-wallpaper.sh || ~/.config/hypr/workspace-wallpaper.sh"
	)
	hl.exec_cmd("hyprctl plugin load ~/hyprworkwall/build/libhyprworkwall.so")
	hl.exec_cmd("hyprctl plugin load ~/hyprtasking/build/libhyprtasking.so")
end)

-- ============================================================
--  EXEC on every reload
-- ============================================================

hl.config({
	general = {
		resize_on_border = true,
	},
})

-- ============================================================
--  PERMISSIONS
-- ============================================================
-- hl.config({
-- plugin = {
-- dynamic_cursors = {

-- enables the plugin
-- enabled = true,

-- sets the cursor behaviour, supports these values:
-- tilt    - tilt the cursor based on x-velocity
-- rotate  - rotate the cursor based on movement direction
-- stretch - stretch the cursor shape based on direction and velocity
-- none    - do not change the cursor's behaviour
-- mode = "tilt",

-- minimum angle difference in degrees after which the shape is changed
-- smaller values are smoother, but more expensive for hw cursors
-- threshold = 2,

-- for mode = "rotate"
-- rotate = {

-- length in px of the simulated stick used to rotate the cursor
-- most realistic if this is your actual cursor size
-- length = 20,

-- clockwise offset applied to the angle in degrees
-- this will apply to ALL shapes
-- offset = 0.0,
--},

-- for mode = "tilt"
-- tilt = {

-- controls how powerful the tilt is, the lower, the more power
-- this value controls at which speed (px/s) the full tilt is reached
-- limit = 5000,

-- relationship between speed and tilt, supports these values:
-- linear             - a linear function is used
-- quadratic          - a quadratic function is used (most realistic to actual air drag)
-- negative_quadratic - negative version of the quadratic one, feels more aggressive
-- see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
-- activation = "negative_quadratic",

-- time window (ms) over which the speed is calculated
-- higher values will make slow motions smoother but more delayed
-- window = 100,

-- full tilt for each side (°)
-- full = 60,
-- },

-- for mode = "stretch"
-- stretch = {

-- controls how much the cursor is stretched
-- this value controls at which speed (px/s) the full stretch is reached
-- the full stretch being twice the original length
-- limit = 3000,

-- relationship between speed and stretch amount, supports these values:
-- linear             - a linear function is used
-- quadratic          - a quadratic function is used
-- negative_quadratic - negative version of the quadratic one, feels more aggressive
-- see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
-- activation = "quadratic",

-- time window (ms) over which the speed is calculated
-- higher values will make slow motions smoother but more delayed
-- window = 100,
-- },

-- configure shake to find
-- magnifies the cursor if its is being shaken
-- shake = {

-- enables shake to find
--	enabled = true,

-- controls how soon a shake is detected
-- lower values mean sooner
--threshold = 6.0,

-- magnification level immediately after shake start
--	base = 4.0,
-- magnification increase per second when continuing to shake
--speed = 4.0,
-- how much the speed is influenced by the current shake intensity
--influence = 0.0,

-- maximal magnification the cursor can reach
-- values below 1 disable the limit (e.g. 0)
--limit = 0.0,

-- time in milliseconds the cursor will stay magnified after a shake has ended
--timeout = 2000,

-- show cursor behaviour `tilt`, `rotate`, etc. while shaking
--effects = false,

-- enable ipc events for shake
-- see the `ipc` section below
--ipc = false,
--},

-- use hyprcursor to get a higher resolution texture when the cursor is magnified
-- see the `hyprcursor` section below
--hyprcursor = {

-- use nearest-neighbour (pixelated) scaling when magnifying beyond texture size
-- this will also have effect without hyprcursor support being enabled
-- 0 - never use pixelated scaling
-- 1 - use pixelated when no highres image
-- 2 - always use pixelated scaling
--nearest = 1,

-- enable dedicated hyprcursor support
--enabled = true,

-- resolution in pixels to load the magnified shapes at
-- be warned that loading a very high-resolution image will take a long time and might impact memory consumption
-- -1 means we use [normal cursor size] * [shake:base option]
--	resolution = -1,

-- shape to use when clientside cursors are being magnified
-- see the shape-name property of shape rules for possible names
-- specifying clientside will use the actual shape, but will be pixelated
--	fallback = "clientside",
--	},
--	},
--},
--})
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
plugin = {
	hyprspace = {
		hide_real_layers = false,
		hide_top_layers = false,
		hide_overlay_layers = false,
	},
}
Plugin = {
	hyprspace = {
		panel_height = 200,
		reserved_area = 0,
		affect_strut = false,
		on_bottom = false,
		center_aligned = true,
		hide_real_layers = false,
		hide_top_layers = false,
		hide_overlay_layers = false,
	},
}

-- [hyprconf-gui] load GUI-managed overrides last, every reload
dofile("/home/autometalogolex/.config/hypr/overrides.lua")
