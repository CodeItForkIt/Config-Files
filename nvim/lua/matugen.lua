 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#12212b',
    base01 = '#1e3648',
    base02 = '#1b3141',
    base03 = '#606c70',
    base04 = '#afb4b6',
    base05 = '#f2f3f3',
    base06 = '#f2f3f3',
    base07 = '#f2f3f3',
    base08 = '#fd4663',
    base09 = '#8066cc',
    base0A = '#5c7ad6',
    base0B = '#67c5e4',
    base0C = '#ab96e9',
    base0D = '#93d6ec',
    base0E = '#96aae9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f3f3',          bg = '#12212b' })
  hi('TelescopeBorder',         { fg = '#606c70',             bg = '#12212b' })
  hi('TelescopePromptNormal',   { fg = '#f2f3f3',          bg = '#12212b' })
  hi('TelescopePromptBorder',   { fg = '#606c70',             bg = '#12212b' })
  hi('TelescopePromptPrefix',   { fg = '#67c5e4',             bg = '#12212b' })
  hi('TelescopePromptCounter',  { fg = '#afb4b6',  bg = '#12212b' })
  hi('TelescopePromptTitle',    { fg = '#12212b',             bg = '#67c5e4' })
  hi('TelescopePreviewTitle',   { fg = '#12212b',             bg = '#5c7ad6' })
  hi('TelescopeResultsTitle',   { fg = '#12212b',             bg = '#8066cc' })
  hi('TelescopeSelection',      { fg = '#f2f3f3',          bg = '#1b3141' })
  hi('TelescopeSelectionCaret', { fg = '#67c5e4',             bg = '#1b3141' })
  hi('TelescopeMatching',       { fg = '#67c5e4',             bold = true })
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
