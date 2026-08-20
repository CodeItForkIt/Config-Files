 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#292114',
    base01 = '#453721',
    base02 = '#3e321e',
    base03 = '#716b61',
    base04 = '#b6b3af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#c4854c',
    base09 = '#92f454',
    base0A = '#e2f454',
    base0B = '#f4b757',
    base0C = '#b3f787',
    base0D = '#f7cc87',
    base0E = '#ebf787',
    base0F = '#4a2d14',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#292114' })
  hi('TelescopeBorder',         { fg = '#716b61',             bg = '#292114' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#292114' })
  hi('TelescopePromptBorder',   { fg = '#716b61',             bg = '#292114' })
  hi('TelescopePromptPrefix',   { fg = '#f4b757',             bg = '#292114' })
  hi('TelescopePromptCounter',  { fg = '#b6b3af',  bg = '#292114' })
  hi('TelescopePromptTitle',    { fg = '#292114',             bg = '#f4b757' })
  hi('TelescopePreviewTitle',   { fg = '#292114',             bg = '#e2f454' })
  hi('TelescopeResultsTitle',   { fg = '#292114',             bg = '#92f454' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#3e321e' })
  hi('TelescopeSelectionCaret', { fg = '#f4b757',             bg = '#3e321e' })
  hi('TelescopeMatching',       { fg = '#f4b757',             bold = true })
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
