-- ============================================================
--  windowrules.lua  —  Hyprland 0.55+ Lua
--  Confirmed from wiki:
--    move = {x, y} or move = {"expr", "expr"} — table, not string
--    match = { float = true } IS valid per wiki example
--    workspace_rule no_border/no_rounding for gap-less ws
--    match = { fullscreen = true } is valid
-- ============================================================

-- ============================================================
--  IDLE INHIBIT
-- ============================================================

hl.window_rule({
	name = "idle-inhibit-media",
	match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" },
	idle_inhibit = "fullscreen",
})
hl.window_rule({
	name = "idle-inhibit-spotify",
	match = { class = "^(.*[Ss]potify.*)$" },
	idle_inhibit = "fullscreen",
})
hl.window_rule({
	name = "idle-inhibit-browsers",
	match = {
		class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*Brave.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$",
	},
	idle_inhibit = "fullscreen",
})
hl.config({
	input = {
		follow_mouse = 1,
		mouse_refocus = false,
	},
})
-- In windowrules.lua
hl.window_rule({
	match = { class = "^(bg3)$" },
	workspace = "special",
	fullscreen = true,
})

-- ============================================================
--  PICTURE-IN-PICTURE
-- ============================================================

hl.window_rule({
	name = "pip",
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	float = true,
	keep_aspect_ratio = true,
	move = { "(monitor_w*0.73)", "(monitor_h*0.72)" },
	size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
	pin = true,
})

hl.window_rule({
	name = "hyprtile",
	match = { class = "HyprTile" },
	float = true,
	center = true,
	no_anim = true,
	no_blur = true,
})
-- ============================================================
--  FLOAT — by class
-- ============================================================

local float_classes = {
	{ name = "satty", class = "^(com.gabm.satty)$" },
	{ name = "vlc", class = "^(vlc)$" },
	{ name = "kvantum", class = "^(kvantummanager)$" },
	{ name = "qt5ct", class = "^(qt5ct)$" },
	{ name = "qt6ct", class = "^(qt6ct)$" },
	{ name = "nwg-look", class = "^(nwg-look)$" },
	{ name = "nwg-displays", class = "^(nwg-displays)$" },
	{ name = "ark", class = "^(org.kde.ark)$" },
	{ name = "pavucontrol", class = "^(org.pulseaudio.pavucontrol)$" },
	{ name = "blueman", class = "^(blueman-manager)$" },
	{ name = "nm-applet", class = "^(nm-applet)$" },
	{ name = "nm-editor", class = "^(nm-connection-editor)$" },
	{ name = "polkit-kde", class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
	{ name = "xdg-portal-gtk", class = "^([Xx]dg-desktop-portal-gtk)$" },
	{ name = "signal", class = "^(Signal)$" },
	{ name = "clapper", class = "^(com.github.rafostar.Clapper)$" },
	{ name = "warp", class = "^(app.drey.Warp)$" },
	{ name = "protonup", class = "^(net.davidotek.pupgui2)$" },
	{ name = "yad", class = "^(yad)$" },
	{ name = "eog", class = "^(eog)$" },
	{ name = "planify", class = "^(io.github.alainm23.planify)$" },
	{ name = "upscaler", class = "^(io.gitlab.theevilskeleton.Upscaler)$" },
	{ name = "videodownloader", class = "^(com.github.unrud.VideoDownloader)$" },
	{ name = "impression", class = "^(io.gitlab.adhami3310.Impression)$" },
	{ name = "missioncenter", class = "^(io.missioncenter.MissionCenter)$" },
	{ name = "dialog-class", class = "^(.*dialog.*)$" },
}

for _, r in ipairs(float_classes) do
	hl.window_rule({ name = r.name, match = { class = r.class }, float = true })
end

-- Float — class + title
hl.window_rule({
	name = "dolphin-progress",
	match = { class = "^(org.kde.dolphin)$", title = "^(Progress Dialog — Dolphin)$" },
	float = true,
})
hl.window_rule({
	name = "dolphin-copy",
	match = { class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" },
	float = true,
})
hl.window_rule({
	name = "firefox-pip",
	match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
	float = true,
})
hl.window_rule({
	name = "firefox-lib",
	match = { class = "^(firefox)$", title = "^(Library)$" },
	float = true,
})
hl.window_rule({
	name = "kitty-top",
	match = { class = "^(kitty)$", title = "^(top)$" },
	float = true,
})
hl.window_rule({
	name = "kitty-btop",
	match = { class = "^(kitty)$", title = "^(btop)$" },
	float = true,
})
hl.window_rule({
	name = "kitty-htop",
	match = { class = "^(kitty)$", title = "^(htop)$" },
	float = true,
})

-- Float — title only
local float_titles = {
	{ name = "about-firefox", title = "^(About Mozilla Firefox)$" },
	{ name = "dialog-open", title = "^(Open)$" },
	{ name = "auth-required", title = "^(Authentication Required)$" },
	{ name = "add-folder", title = "^(Add Folder to Workspace)$" },
	{ name = "choose-files", title = "^(Choose Files)$" },
	{ name = "save-as", title = "^(Save As)$" },
	{ name = "confirm-replace", title = "^(Confirm to replace files)$" },
	{ name = "file-op-prog", title = "^(File Operation Progress)$" },
	{ name = "file-upload", title = "^(File Upload)(.*)$" },
	{ name = "choose-wallpaper", title = "^(Choose wallpaper)(.*)$" },
	{ name = "library", title = "^(Library)(.*)$" },
	{ name = "dialog-title", title = "^(.*dialog.*)$" },
}

for _, r in ipairs(float_titles) do
	hl.window_rule({ name = r.name, match = { title = r.title }, float = true })
end

-- ============================================================
--  WORKSPACE RULES
--  Wiki: no_border and no_rounding belong in workspace_rule
-- ============================================================

-- Games → special workspace
hl.window_rule({
	name = "steam-notification-toast",
	-- title is "notificationtoasts_<id>_desktop", id changes every time
	match = { title = "^(notificationtoasts_.*_desktop)$" },
	workspace = "special:Games silent",
	no_initial_focus = true,
	no_focus = true,
})
hl.window_rule({
	name = "games-steam-app",
	match = { class = "^(steam_app_.*)$" },
	workspace = "special:Games",
	fullscreen = true,
})
hl.window_rule({
	name = "steam-popup",
	match = { class = "steam" },
	workspace = "special:Games",
	opaque = true,
})
hl.window_rule({
	name = "steam-popup-title",
	match = { class = "^(steam)$", title = "" },
	workspace = "special:Games",
	opaque = true,
})
hl.window_rule({
	name = "games-minecraft",
	match = { class = "^(Minecraft|minecraft)$", title = "^(Minecraft)(.*)$" },
	workspace = "special:Games",
})
hl.window_rule({
	name = "games-mc-title",
	match = { initial_title = "^(Minecraft)(.*)$" },
	workspace = "special:Games",
})
hl.window_rule({
	name = "games-steam",
	match = { class = "^(steam)$" },
	workspace = "special:Games",
})
hl.window_rule({
	name = "games-hytale",
	match = { class = "^(HytaleClient)$" },
	workspace = "special:Games",
})
hl.window_rule({
	name = "games-hytale-l",
	match = { class = "^(com.hypixel.HytaleLauncher)$" },
	workspace = "special:Games",
})

-- Prism Launcher
hl.window_rule({
	name = "prism-console",
	match = { title = "^(Console window for .+ — Prism Launcher 9\\.4)$" },
	float = true,
})
hl.window_rule({
	name = "prism-download",
	match = { title = "^(Download mods — Prism Launcher.*)$" },
	float = true,
	move = { "0", "0" },
	size = { "1920", "1000" },
})
-- Workspace 2: Spotify + Vesktop side by side
hl.window_rule({
	name = "ws2-vesktop",
	match = { class = "^(vesktop)$" },
	workspace = "2",
	move = { "(monitor_w*0.5)", "0" },
	size = { "(monitor_w*0.5)", "(monitor_h*1)" },
})
hl.window_rule({
	name = "ws2-google",
	match = { title = "Sign in - Google Accounts - Vivaldi" },
	float = true,
})
-- Empty workspace
hl.window_rule({ name = "foundry-fs", match = { class = "^(foundry)$" }, workspace = "empty", fullscreen = true })
hl.window_rule({
	name = "Prism Launcher Console Float",
	match = {
		class = "^org%.prismlauncher%.PrismLauncher$",
		title = "^Console window for.*",
	},
	float = true,
})
-- QEMU VMs
hl.window_rule({
	name = "qemu-class",
	match = { class = "^(qemu-system-x86_64|QEMU)$" },
	float = true,
	fullscreen = true,
})
hl.window_rule({
	name = "qemu-title",
	match = { title = "^(QEMU)(.*)$" },
	float = true,
	fullscreen = true,
})

-- Oneko desktop pet
hl.window_rule({
	name = "oneko",
	match = { class = "oneko" },
	float = true,
	no_blur = true,
	no_focus = true,
	no_shadow = true,
	border_size = 0,
})
hl.window_rule({
	name = "prism-console-float",
	match = {
		class = "^(org.prismlauncher.PrismLauncher)$",
		title = "^(Console window.*)$",
	},
	float = true,
})
-- ============================================================
--  LAYER RULES
-- ============================================================
hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
	},
	no_anim = true,
	ignore_alpha = 0,
	blur = true,
	blur_popups = true,
})
hl.layer_rule({
	name = "lr-rofi",
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 1,
})
hl.layer_rule({
	name = "lr-notif",
	match = { namespace = "notifications" },
	blur = true,
	ignore_alpha = 0,
	animation = "slide top",
})
hl.layer_rule({
	name = "lr-swaync-win",
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0,
})
hl.layer_rule({
	name = "lr-swaync-cc",
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0,
})
hl.layer_rule({ name = "lr-logout", match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({
	name = "lr-hyprpanel",
	match = { namespace = "hyprpanel-notifications" },
	blur = true,
	animation = "slide top",
})
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
-- Keep workspaces 1-9 alive even when empty, so hyprtasking's overview (and
-- hyprworkwall's per-workspace wallpapers) always has a real workspace to
-- render per tile instead of falling back for never-visited ones.
for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), persistent = true })
end
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { class = ".*" }, rounding = 20 })
hl.window_rule({ match = { fullscreen = true }, opaque = true })
hl.window_rule({ match = { class = "steam" }, opaque = true })
hl.window_rule({
	name = "float-thunar-popups",
	match = {
		class = "thunar",
		title = "^(?!.*- Thunar$).+$",
	},
	float = true,
	center = true,
})
