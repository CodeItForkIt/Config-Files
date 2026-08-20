 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#0f182e',
    base01 = '#1a294c',
    base02 = '#172545',
    base03 = '#606570',
    base04 = '#afb1b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#ad66cc',
    base0A = '#745cd6',
    base0B = '#678de4',
    base0C = '#d096e9',
    base0D = '#93aeec',
    base0E = '#a696e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#0f182e' })
  hi('TelescopeBorder',         { fg = '#606570',             bg = '#0f182e' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#0f182e' })
  hi('TelescopePromptBorder',   { fg = '#606570',             bg = '#0f182e' })
  hi('TelescopePromptPrefix',   { fg = '#678de4',             bg = '#0f182e' })
  hi('TelescopePromptCounter',  { fg = '#afb1b6',  bg = '#0f182e' })
  hi('TelescopePromptTitle',    { fg = '#0f182e',             bg = '#678de4' })
  hi('TelescopePreviewTitle',   { fg = '#0f182e',             bg = '#745cd6' })
  hi('TelescopeResultsTitle',   { fg = '#0f182e',             bg = '#ad66cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#172545' })
  hi('TelescopeSelectionCaret', { fg = '#678de4',             bg = '#172545' })
  hi('TelescopeMatching',       { fg = '#678de4',             bold = true })
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
