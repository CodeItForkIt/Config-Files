-- ============================================================
--  overrides.lua
--  Managed by HyprConf GUI -- DO NOT EDIT BY HAND.
--  This file is fully regenerated every time you save in the
--  app, so any manual edits here will be lost. Change your base
--  .lua files directly for anything that should survive outside
--  the GUI.
--  Last generated: 2026-08-10T18:34:13
-- ============================================================

hl.config({
	animations = {
		enabled = true,
	},
	decoration = {
		active_opacity = 1.0,
		blur = {
			enabled = true,
		},
		inactive_opacity = 1.0,
		rounding = 20,
		shadow = {
			sharp = false,
			range = 3,
		},
		rounding_power = 0.44999999999999873,
		dim_modal = true,
	},
	general = {
		border_size = 1,
		gaps_in = 2,
		layout = "dwindle",
		snap = {
			enabled = true,
			window_gap = false,
			border_overlap = false,
		},
		float_gaps = 0,
		gaps_workspaces = false,
		modal_parent_blocking = false,
	},
	gestures = {
		workspace_swipe_distance = false,
	},
})

hl.animation({
	speed = 1,
	bezier = "liner",
	enabled = false,
	leaf = "border",
})
