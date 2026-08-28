-- ============================================================
--  scrolling-niri.lua  —  Hyprland 0.55+ Lua
--  Enables Hyprland's native "scrolling" layout (core algorithm,
--  src/layout/algorithm/tiled/scrolling/) and tunes it to feel
--  like Niri's scrolling-tile layout: windows as columns on an
--  infinite horizontal tape, one column fills the screen when
--  alone, and the view auto-scrolls to keep focus in frame.
--
--  This is NOT a custom hl.layout.register() algorithm — Hyprland
--  ships this layout natively as of 0.55, so a hand-written Lua
--  recalculate() would just be reinventing something the compositor
--  already does better. See:
--  https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
--
--  NOTE: hl.config() reloads live the moment this file is saved.
--  Switching `general.layout` away from dwindle will immediately
--  re-tile every open window on every workspace. To revert instantly:
--  comment out the `require("scrolling-niri")` line in hyprland.lua
--  (or just change `layout` back to "dwindle" below) and save.
-- ============================================================

local mainMod = "SUPER"

-- ------------------------------------------------------------
--  Activate the layout
-- ------------------------------------------------------------
hl.config({
	general = {
		layout = "scrolling",
	},
})

-- ------------------------------------------------------------
--  Scrolling layout tuning (category `scrolling`)
--  https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/#config
-- ------------------------------------------------------------
hl.config({
	scrolling = {
		-- a single column on a workspace always fills the whole screen
		-- (this is what makes a lone window look like any other layout)
		fullscreen_on_one_column = false,

		-- default width for a newly created column, as a fraction of the monitor
		column_width = 0.5,

		-- 0 = center the focused column in the viewport, 1 = fit
		-- (scroll just enough to bring it fully into view, no more).
		-- Niri's default feel is "fit".
		focus_fit_method = 1,

		-- auto-scroll the view when focus changes (arrow keys, alt-tab, etc.)
		follow_focus = true,
		-- ...but only if focus-follow would otherwise leave less than this
		-- fraction of the newly focused window visible. Direct input
		-- (binds, clicks) always follows regardless of this.
		follow_min_visible = 0.4,

		-- preset widths cycled by "colresize +conf" / "colresize -conf" below
		-- (thirds / half / two-thirds / full — Niri's usual default cycle)
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",

		-- wrap at the first/last column instead of stopping
		wrap_focus = true,
		wrap_swapcol = true,

		-- which way new columns are added / the tape scrolls
		direction = "right",
	},
})

-- Per-workspace direction override example (uncomment + adjust):
-- hl.workspace_rule({ workspace = "2", layout_opts = { direction = "down" } })

-- Give a specific app a different starting column width. Example: make
-- your terminal open at half width instead of the 0.5 global default.
hl.window_rule({
	name = "scrolling-kitty-width",
	match = { class = "kitty" },
	scrolling_width = 0.5,
})

-- ------------------------------------------------------------
--  Keybindings — layout messages via hl.dsp.layout(msg)
--  https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/#layout-messages
--
--  Your existing SUPER + Left/Right/Up/Down binds (keybindings.lua)
--  already do directional focus and work fine for moving between
--  columns and up/down a stack. They're left untouched here. If you
--  want Niri's exact "wrap + scroll to bring the column into view"
--  focus behavior instead of generic directional focus, swap the
--  Left/Right ones (keep Up/Down generic, for moving within a
--  stacked column) for:
--    hl.bind(mainMod .. " + Left",  hl.dsp.layout("focus l"), { desc = "focus column left" })
--    hl.bind(mainMod .. " + Right", hl.dsp.layout("focus r"), { desc = "focus column right" })
--
--  Fullscreen is already bound to SHIFT + F11 in keybindings.lua via
--  hl.dsp.window.fullscreen(), which defaults to layout_aware = true —
--  so it already gets Niri's "scroll away from a fullscreen window
--  without un-fullscreening it" behavior for free, no change needed.
-- ------------------------------------------------------------

-- Reorder columns (move the focused column itself, not just focus)
hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("swapcol l"), { desc = "move column left" })
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("swapcol r"), { desc = "move column right" })

-- Cycle through the preset widths above (thirds / half / two-thirds / full)
hl.bind(mainMod .. " + minus", hl.dsp.layout("colresize -conf"), { desc = "column width: smaller preset" })
hl.bind(mainMod .. " + equal", hl.dsp.layout("colresize +conf"), { desc = "column width: larger preset" })

-- Freeform column resize
hl.bind(
	mainMod .. " + SHIFT + minus",
	hl.dsp.layout("colresize -0.05"),
	{ desc = "column width: shrink 5%", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + equal",
	hl.dsp.layout("colresize +0.05"),
	{ desc = "column width: grow 5%", repeating = true }
)

-- Bring the current column fully into view / expand it into free space
hl.bind(mainMod .. " + semicolon", hl.dsp.layout("fit active"), { desc = "scroll active column into view" })
hl.bind(mainMod .. " + backslash", hl.dsp.layout("fit expand"), { desc = "expand column into free space" })

-- Stack windows into a column / pop them back out (niri's consume/expel)
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("consume"), { desc = "stack window into previous column" })
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("expel"), { desc = "pop window into its own column" })
hl.bind(mainMod .. " + slash", hl.dsp.layout("promote"), { desc = "promote window to its own new column" })

-- Freeze the scroll view for this workspace (toggle)
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.layout("inhibit_scroll"), { desc = "toggle scroll-view lock" })
