 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#191f24',
    base01 = '#2a343c',
    base02 = '#262e36',
    base03 = '#616a71',
    base04 = '#afb3b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#9a6cce',
    base0A = '#6266d8',
    base0B = '#67a9e4',
    base0C = '#bd96e9',
    base0D = '#93c2ec',
    base0E = '#9699e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#191f24' })
  hi('TelescopeBorder',         { fg = '#616a71',             bg = '#191f24' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#191f24' })
  hi('TelescopePromptBorder',   { fg = '#616a71',             bg = '#191f24' })
  hi('TelescopePromptPrefix',   { fg = '#67a9e4',             bg = '#191f24' })
  hi('TelescopePromptCounter',  { fg = '#afb3b6',  bg = '#191f24' })
  hi('TelescopePromptTitle',    { fg = '#191f24',             bg = '#67a9e4' })
  hi('TelescopePreviewTitle',   { fg = '#191f24',             bg = '#6266d8' })
  hi('TelescopeResultsTitle',   { fg = '#191f24',             bg = '#9a6cce' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#262e36' })
  hi('TelescopeSelectionCaret', { fg = '#67a9e4',             bg = '#262e36' })
  hi('TelescopeMatching',       { fg = '#67a9e4',             bold = true })
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
