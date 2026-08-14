 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#181d25',
    base01 = '#29303d',
    base02 = '#252c37',
    base03 = '#616871',
    base04 = '#afb2b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#a566cc',
    base0A = '#695cd6',
    base0B = '#6797e4',
    base0C = '#c996e9',
    base0D = '#93b5ec',
    base0E = '#9f96e9',
    base0F = '#910017',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#181d25' })
  hi('TelescopeBorder',         { fg = '#616871',             bg = '#181d25' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#181d25' })
  hi('TelescopePromptBorder',   { fg = '#616871',             bg = '#181d25' })
  hi('TelescopePromptPrefix',   { fg = '#6797e4',             bg = '#181d25' })
  hi('TelescopePromptCounter',  { fg = '#afb2b6',  bg = '#181d25' })
  hi('TelescopePromptTitle',    { fg = '#181d25',             bg = '#6797e4' })
  hi('TelescopePreviewTitle',   { fg = '#181d25',             bg = '#695cd6' })
  hi('TelescopeResultsTitle',   { fg = '#181d25',             bg = '#a566cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#252c37' })
  hi('TelescopeSelectionCaret', { fg = '#6797e4',             bg = '#252c37' })
  hi('TelescopeMatching',       { fg = '#6797e4',             bold = true })
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
