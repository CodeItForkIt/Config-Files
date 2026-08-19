 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#171e26',
    base01 = '#263240',
    base02 = '#232d39',
    base03 = '#616971',
    base04 = '#afb2b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#9b66cc',
    base0A = '#5e5cd6',
    base0B = '#67a4e4',
    base0C = '#c196e9',
    base0D = '#93beec',
    base0E = '#9796e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#171e26' })
  hi('TelescopeBorder',         { fg = '#616971',             bg = '#171e26' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#171e26' })
  hi('TelescopePromptBorder',   { fg = '#616971',             bg = '#171e26' })
  hi('TelescopePromptPrefix',   { fg = '#67a4e4',             bg = '#171e26' })
  hi('TelescopePromptCounter',  { fg = '#afb2b6',  bg = '#171e26' })
  hi('TelescopePromptTitle',    { fg = '#171e26',             bg = '#67a4e4' })
  hi('TelescopePreviewTitle',   { fg = '#171e26',             bg = '#5e5cd6' })
  hi('TelescopeResultsTitle',   { fg = '#171e26',             bg = '#9b66cc' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#232d39' })
  hi('TelescopeSelectionCaret', { fg = '#67a4e4',             bg = '#232d39' })
  hi('TelescopeMatching',       { fg = '#67a4e4',             bold = true })
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
