 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#0d2830',
    base01 = '#164250',
    base02 = '#143c48',
    base03 = '#627172',
    base04 = '#afb6b6',
    base05 = '#f2f3f3',
    base06 = '#f2f3f3',
    base07 = '#f2f3f3',
    base08 = '#fd4663',
    base09 = '#675fd3',
    base0A = '#5c91d6',
    base0B = '#67dce4',
    base0C = '#9c96e9',
    base0D = '#93e6ec',
    base0E = '#96bae9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f3f3',          bg = '#0d2830' })
  hi('TelescopeBorder',         { fg = '#627172',             bg = '#0d2830' })
  hi('TelescopePromptNormal',   { fg = '#f2f3f3',          bg = '#0d2830' })
  hi('TelescopePromptBorder',   { fg = '#627172',             bg = '#0d2830' })
  hi('TelescopePromptPrefix',   { fg = '#67dce4',             bg = '#0d2830' })
  hi('TelescopePromptCounter',  { fg = '#afb6b6',  bg = '#0d2830' })
  hi('TelescopePromptTitle',    { fg = '#0d2830',             bg = '#67dce4' })
  hi('TelescopePreviewTitle',   { fg = '#0d2830',             bg = '#5c91d6' })
  hi('TelescopeResultsTitle',   { fg = '#0d2830',             bg = '#675fd3' })
  hi('TelescopeSelection',      { fg = '#f2f3f3',          bg = '#143c48' })
  hi('TelescopeSelectionCaret', { fg = '#67dce4',             bg = '#143c48' })
  hi('TelescopeMatching',       { fg = '#67dce4',             bold = true })
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
