 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#141b29',
    base01 = '#222d44',
    base02 = '#1f293d',
    base03 = '#606774',
    base04 = '#afb1b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#aa66cc',
    base0A = '#705cd6',
    base0B = '#6791e4',
    base0C = '#cd96e9',
    base0D = '#93b1ec',
    base0E = '#a396e9',
    base0F = '#910017',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#141b29' })
  hi('TelescopeBorder',         { fg = '#606774',             bg = '#141b29' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#141b29' })
  hi('TelescopePromptBorder',   { fg = '#606774',             bg = '#141b29' })
  hi('TelescopePromptPrefix',   { fg = '#6791e4',             bg = '#141b29' })
  hi('TelescopePromptCounter',  { fg = '#afb1b6',  bg = '#141b29' })
  hi('TelescopePromptTitle',    { fg = '#141b29',             bg = '#6791e4' })
  hi('TelescopePreviewTitle',   { fg = '#141b29',             bg = '#705cd6' })
  hi('TelescopeResultsTitle',   { fg = '#141b29',             bg = '#aa66cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#1f293d' })
  hi('TelescopeSelectionCaret', { fg = '#6791e4',             bg = '#1f293d' })
  hi('TelescopeMatching',       { fg = '#6791e4',             bold = true })
end

 -- Register a signal handler for SIGUSR1 (matugen updates)
 local signal = vim.uv.new_signal()
 signal:start(
   'sigusr1',
   vim.schedule_wrap(function()
     package.loaded['matugen'] = nil
     require('matugen').setup()
   end)
 )

 return M
