-- ============================================================
--  userprefs.lua  —  Hyprland 0.55+ Lua
--  User preference overrides.
--  Transparency (active 0.90, inactive 0.75) is kept from
--  hyprland.lua — do NOT override opacity here.
-- ============================================================

hl.config({
	general = {
		border_size = 0,
		gaps_out = 0,
	},

	decoration = {
		-- opacity intentionally NOT overridden — keeping slight transparency
		blur = {
			enabled = false,
		},
	},

	input = {
		touchpad = {
			natural_scroll = false,
		},
	},

	misc = {
		enable_swallow = true,
	},

	xwayland = {
		use_nearest_neighbor = false,
	},
})

hl.env("HYPRCURSOR_THEME", "Nordzy")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
