-- ============================================================
--  hyprland.lua  —  Hyprland 0.55+ Lua config
-- ============================================================

require("monitors")
require("animations")
require("windowrules")
require("keybindings")
require("userprefs")

-- ============================================================
--  VARIABLES
-- ============================================================

local home = os.getenv("HOME")
local scrPath = home .. "/.local/lib/hyde"
local FONT = "Cantarell"

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

-- ============================================================
--  CORE CONFIGURATION
-- ============================================================

hl.config({
	general = {
		snap = { enabled = true },
	},

	decoration = {
		dim_special = 0.3,
		active_opacity = 0.90,
		inactive_opacity = 0.75,
		fullscreen_opacity = 1.0,
		blur = {
			special = true,
		},
	},

	input = {
		accel_profile = "flat",
		numlock_by_default = true,
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
		font_family = FONT,
		enable_swallow = true,
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
	hl.exec_cmd(
		"uwsm app -t service -s s -- " .. scrPath .. "/waybar.py --watch || " .. scrPath .. "/waybar.py --watch"
	)
	hl.exec_cmd("uwsm app -t service -s s -- dunst || dunst")
	hl.exec_cmd("uwsm app -t service -s a -- blueman-applet || blueman-applet")
	hl.exec_cmd(
		"uwsm app -t service -s b -- " .. scrPath .. "/wallpaper.sh --global || " .. scrPath .. "/wallpaper.sh --global"
	)
	hl.exec_cmd("uwsm app -t service -s s -- wl-paste --type text --watch cliphist store")
	hl.exec_cmd("uwsm app -t service -s s -- wl-paste --type image --watch cliphist store")
	hl.exec_cmd("uwsm app -t service -s s -- wl-clip-persist --clipboard regular")
	hl.exec_cmd("uwsm app -t service -s a -- " .. scrPath .. "/batterynotify.sh")
	hl.exec_cmd("uwsm app -t service -s a -- nm-applet --indicator")
	hl.exec_cmd("uwsm app -t service -s a -- udiskie --no-automount --smart-tray")
	hl.exec_cmd("uwsm app -t service -s s -- " .. scrPath .. "/polkitkdeauth.sh")
	hl.exec_cmd("uwsm app -t service -s s -- hypridle")
	hl.exec_cmd("systemctl --user start hyde-config.service")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("hyprpm reload")
	hl.exec_cmd("hyprctl setcursor Nordzy-hyprcursors-catppuccin-frappe-dark 23")
	hl.exec_cmd(home .. "/.config/hypr/scripts/hyprpanel.sh")
	hl.exec_cmd("nvidia-modprobe")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("sleep 5 && pkill dunst")
	hl.exec_cmd("sudo systemctl restart systemd-resolved")
	hl.exec_cmd("sunshine")
	-- Workspace startup apps — dispatch rule prefix syntax confirmed from wiki
	hl.exec_cmd("[workspace 1 silent] kitty")
	hl.exec_cmd("[workspace 1 silent] vivaldi")
	hl.exec_cmd("[workspace 2 silent] flatpak run com.spotify.Client")
	hl.exec_cmd("WAYLAND_DISPLAY=wayland-1 steam")
	hl.exec_cmd("~/.config/scripts/cfg-watch.sh > /tmp/cfg-watch.log 2>&1 &")
	hl.exec_cmd("wayle panel start")
	hl.exec_cmd(home .. "/.config/hypr/workspace-wallpaper.sh")
end)

-- ============================================================
--  EXEC on every reload
-- ============================================================

hl.on("config.reloaded", function()
	hl.exec_cmd(scrPath .. "/keybinds.hint.py --format rofi > " .. xdgRuntime .. "/hyde/keybinds_hint.rofi")
end)

-- ============================================================
--  PERMISSIONS
-- ============================================================

hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
