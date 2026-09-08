 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#121b2b',
    base01 = '#1e2d48',
    base02 = '#1b2941',
    base03 = '#616771',
    base04 = '#afb1b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#a766cc',
    base0A = '#6d5cd6',
    base0B = '#6794e4',
    base0C = '#cb96e9',
    base0D = '#93b3ec',
    base0E = '#a196e9',
    base0F = '#c5bef4',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#121b2b' })
  hi('TelescopeBorder',         { fg = '#616771',             bg = '#121b2b' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#121b2b' })
  hi('TelescopePromptBorder',   { fg = '#616771',             bg = '#121b2b' })
  hi('TelescopePromptPrefix',   { fg = '#6794e4',             bg = '#121b2b' })
  hi('TelescopePromptCounter',  { fg = '#afb1b6',  bg = '#121b2b' })
  hi('TelescopePromptTitle',    { fg = '#121b2b',             bg = '#6794e4' })
  hi('TelescopePreviewTitle',   { fg = '#121b2b',             bg = '#6d5cd6' })
  hi('TelescopeResultsTitle',   { fg = '#121b2b',             bg = '#a766cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#1b2941' })
  hi('TelescopeSelectionCaret', { fg = '#6794e4',             bg = '#1b2941' })
  hi('TelescopeMatching',       { fg = '#6794e4',             bold = true })
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
