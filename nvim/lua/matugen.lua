 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#141b2a',
    base01 = '#212d45',
    base02 = '#1e283e',
    base03 = '#616771',
    base04 = '#afb1b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#ab66cc',
    base0A = '#705cd6',
    base0B = '#6790e4',
    base0C = '#ce96e9',
    base0D = '#93b0ec',
    base0E = '#a396e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#141b2a' })
  hi('TelescopeBorder',         { fg = '#616771',             bg = '#141b2a' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#141b2a' })
  hi('TelescopePromptBorder',   { fg = '#616771',             bg = '#141b2a' })
  hi('TelescopePromptPrefix',   { fg = '#6790e4',             bg = '#141b2a' })
  hi('TelescopePromptCounter',  { fg = '#afb1b6',  bg = '#141b2a' })
  hi('TelescopePromptTitle',    { fg = '#141b2a',             bg = '#6790e4' })
  hi('TelescopePreviewTitle',   { fg = '#141b2a',             bg = '#705cd6' })
  hi('TelescopeResultsTitle',   { fg = '#141b2a',             bg = '#ab66cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#1e283e' })
  hi('TelescopeSelectionCaret', { fg = '#6790e4',             bg = '#1e283e' })
  hi('TelescopeMatching',       { fg = '#6790e4',             bold = true })
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
