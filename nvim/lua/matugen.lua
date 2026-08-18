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
    base08 = '#c5874d',
    base09 = '#99f665',
    base0A = '#e2f665',
    base0B = '#f6c265',
    base0C = '#aff887',
    base0D = '#f8cf87',
    base0E = '#e8f887',
    base0F = '#4c2f14',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f3f2f2',          bg = '#292214' })
  hi('TelescopeBorder',         { fg = '#716c61',             bg = '#292214' })
  hi('TelescopePromptNormal',   { fg = '#f3f2f2',          bg = '#292214' })
  hi('TelescopePromptBorder',   { fg = '#716c61',             bg = '#292214' })
  hi('TelescopePromptPrefix',   { fg = '#f6c265',             bg = '#292214' })
  hi('TelescopePromptCounter',  { fg = '#b6b4af',  bg = '#292214' })
  hi('TelescopePromptTitle',    { fg = '#292214',             bg = '#f6c265' })
  hi('TelescopePreviewTitle',   { fg = '#292214',             bg = '#e2f665' })
  hi('TelescopeResultsTitle',   { fg = '#292214',             bg = '#99f665' })
  hi('TelescopeSelection',      { fg = '#f3f2f2',          bg = '#3e321e' })
  hi('TelescopeSelectionCaret', { fg = '#f6c265',             bg = '#3e321e' })
  hi('TelescopeMatching',       { fg = '#f6c265',             bold = true })
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
