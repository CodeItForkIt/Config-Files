-- ============================================================
--  overrides.lua
--  Managed by HyprConf GUI -- DO NOT EDIT BY HAND.
--  This file is fully regenerated every time you save in the
--  app, so any manual edits here will be lost. Change your base
--  .lua files directly for anything that should survive outside
--  the GUI.
--  Last generated: 2026-08-18T11:05:06
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
		dim_modal = true,
		inactive_opacity = 1.0,
		rounding = 20,
		rounding_power = 0.44999999999999873,
		shadow = {
			range = 3,
			sharp = false,
		},
	},
	general = {
		border_size = 1,
		float_gaps = 0,
		gaps_in = 2,
		gaps_workspaces = false,
		layout = "scrolling",
		modal_parent_blocking = false,
		snap = {
			border_overlap = false,
			enabled = true,
			window_gap = false,
		},
	},
	gestures = {
		workspace_swipe_distance = false,
	},
	ecosystem = {
		no_donation_nag = true,
	},
	scrolling = {
		follow_focus = true,
	},
})

hl.animation({
	bezier = "liner",
	enabled = false,
	leaf = "border",
	speed = 1,
})
