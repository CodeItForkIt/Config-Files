 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#232a2e',
    base01 = '#2d353b',
    base02 = '#363f47',
    base03 = '#7a8478',
    base04 = '#d3c6aa',
    base05 = '#859289',
    base06 = '#859289',
    base07 = '#859289',
    base08 = '#e67e80',
    base09 = '#9da9a0',
    base0A = '#d3c6aa',
    base0B = '#a7c080',
    base0C = '#96e9ab',
    base0D = '#c8e996',
    base0E = '#e9ce96',
    base0F = '#99181b',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#859289',          bg = '#232a2e' })
  hi('TelescopeBorder',         { fg = '#7a8478',             bg = '#232a2e' })
  hi('TelescopePromptNormal',   { fg = '#859289',          bg = '#232a2e' })
  hi('TelescopePromptBorder',   { fg = '#7a8478',             bg = '#232a2e' })
  hi('TelescopePromptPrefix',   { fg = '#a7c080',             bg = '#232a2e' })
  hi('TelescopePromptCounter',  { fg = '#d3c6aa',  bg = '#232a2e' })
  hi('TelescopePromptTitle',    { fg = '#232a2e',             bg = '#a7c080' })
  hi('TelescopePreviewTitle',   { fg = '#232a2e',             bg = '#d3c6aa' })
  hi('TelescopeResultsTitle',   { fg = '#232a2e',             bg = '#9da9a0' })
  hi('TelescopeSelection',      { fg = '#859289',          bg = '#363f47' })
  hi('TelescopeSelectionCaret', { fg = '#a7c080',             bg = '#363f47' })
  hi('TelescopeMatching',       { fg = '#a7c080',             bold = true })
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
