-- lua/config/ui.lua
local M = {}

function M.setup()
  --Transparent background
  local hl = vim.api.nvim_set_hl
  hl(0, "Normal", { bg = "none" })
  hl(0, "NormalNC", { bg = "NONE" })
  hl(0, "SignColumn", { bg = "NONE" })
  hl(0, "VertSplit", { bg = "NONE" })
  hl(0, "StatusLine", { bg = "NONE" })
  hl(0, "StatusLineNC", { bg = "NONE" })
  hl(0, "Pmenu", { bg = "NONE" })
  hl(0, "PmenuSel", { bg = "NONE" })
end

return M
