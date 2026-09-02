 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#292214',
    base01 = '#453821',
    base02 = '#3e321e',
    base03 = '#716c61',
    base04 = '#b6b4af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#fd4663',
    base09 = '#8acc66',
    base0A = '#c4d65c',
    base0B = '#e4b867',
    base0C = '#b3e996',
    base0D = '#eccc93',
    base0E = '#dce996',
    base0F = '#ecf4be',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#292214' })
  hi('TelescopeBorder',         { fg = '#716c61',             bg = '#292214' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#292214' })
  hi('TelescopePromptBorder',   { fg = '#716c61',             bg = '#292214' })
  hi('TelescopePromptPrefix',   { fg = '#e4b867',             bg = '#292214' })
  hi('TelescopePromptCounter',  { fg = '#b6b4af',  bg = '#292214' })
  hi('TelescopePromptTitle',    { fg = '#292214',             bg = '#e4b867' })
  hi('TelescopePreviewTitle',   { fg = '#292214',             bg = '#c4d65c' })
  hi('TelescopeResultsTitle',   { fg = '#292214',             bg = '#8acc66' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#3e321e' })
  hi('TelescopeSelectionCaret', { fg = '#e4b867',             bg = '#3e321e' })
  hi('TelescopeMatching',       { fg = '#e4b867',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
