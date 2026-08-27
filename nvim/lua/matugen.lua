 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#0f1b2e',
    base01 = '#192c4d',
    base02 = '#162845',
    base03 = '#606770',
    base04 = '#afb2b6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#a665cd',
    base0A = '#6b5cd6',
    base0B = '#6796e4',
    base0C = '#ca96e9',
    base0D = '#93b4ec',
    base0E = '#a096e9',
    base0F = '#8f0118',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#0f1b2e' })
  hi('TelescopeBorder',         { fg = '#606770',             bg = '#0f1b2e' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#0f1b2e' })
  hi('TelescopePromptBorder',   { fg = '#606770',             bg = '#0f1b2e' })
  hi('TelescopePromptPrefix',   { fg = '#6796e4',             bg = '#0f1b2e' })
  hi('TelescopePromptCounter',  { fg = '#afb2b6',  bg = '#0f1b2e' })
  hi('TelescopePromptTitle',    { fg = '#0f1b2e',             bg = '#6796e4' })
  hi('TelescopePreviewTitle',   { fg = '#0f1b2e',             bg = '#6b5cd6' })
  hi('TelescopeResultsTitle',   { fg = '#0f1b2e',             bg = '#a665cd' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#162845' })
  hi('TelescopeSelectionCaret', { fg = '#6796e4',             bg = '#162845' })
  hi('TelescopeMatching',       { fg = '#6796e4',             bold = true })
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
