 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#11202c',
    base01 = '#1c354a',
    base02 = '#1a3042',
    base03 = '#616a71',
    base04 = '#afb3b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#9566cc',
    base0A = '#5c60d6',
    base0B = '#67aae4',
    base0C = '#bc96e9',
    base0D = '#93c2ec',
    base0E = '#9699e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#11202c' })
  hi('TelescopeBorder',         { fg = '#616a71',             bg = '#11202c' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#11202c' })
  hi('TelescopePromptBorder',   { fg = '#616a71',             bg = '#11202c' })
  hi('TelescopePromptPrefix',   { fg = '#67aae4',             bg = '#11202c' })
  hi('TelescopePromptCounter',  { fg = '#afb3b6',  bg = '#11202c' })
  hi('TelescopePromptTitle',    { fg = '#11202c',             bg = '#67aae4' })
  hi('TelescopePreviewTitle',   { fg = '#11202c',             bg = '#5c60d6' })
  hi('TelescopeResultsTitle',   { fg = '#11202c',             bg = '#9566cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#1a3042' })
  hi('TelescopeSelectionCaret', { fg = '#67aae4',             bg = '#1a3042' })
  hi('TelescopeMatching',       { fg = '#67aae4',             bold = true })
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
