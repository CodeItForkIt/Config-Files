 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#12202b',
    base01 = '#1e3648',
    base02 = '#1b3040',
    base03 = '#5f6b6f',
    base04 = '#afb4b6',
    base05 = '#f2f3f3',
    base06 = '#f2f3f3',
    base07 = '#f2f3f3',
    base08 = '#fd4663',
    base09 = '#8166cc',
    base0A = '#5c78d6',
    base0B = '#67c3e4',
    base0C = '#ac96e9',
    base0D = '#93d4ec',
    base0E = '#96a9e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f3f3',          bg = '#12202b' })
  hi('TelescopeBorder',         { fg = '#5f6b6f',             bg = '#12202b' })
  hi('TelescopePromptNormal',   { fg = '#f2f3f3',          bg = '#12202b' })
  hi('TelescopePromptBorder',   { fg = '#5f6b6f',             bg = '#12202b' })
  hi('TelescopePromptPrefix',   { fg = '#67c3e4',             bg = '#12202b' })
  hi('TelescopePromptCounter',  { fg = '#afb4b6',  bg = '#12202b' })
  hi('TelescopePromptTitle',    { fg = '#12202b',             bg = '#67c3e4' })
  hi('TelescopePreviewTitle',   { fg = '#12202b',             bg = '#5c78d6' })
  hi('TelescopeResultsTitle',   { fg = '#12202b',             bg = '#8166cc' })
  hi('TelescopeSelection',      { fg = '#f2f3f3',          bg = '#1b3040' })
  hi('TelescopeSelectionCaret', { fg = '#67c3e4',             bg = '#1b3040' })
  hi('TelescopeMatching',       { fg = '#67c3e4',             bold = true })
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
