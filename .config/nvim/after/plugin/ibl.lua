local ok, ibl = pcall(require, "ibl")
if not ok then
  return
end

local hooks = require("ibl.hooks")

-- Define colors for highlights
local rainbow_colors = {
  RainbowRed    = "#E06C75",
  RainbowYellow = "#E5C07B",
  RainbowBlue   = "#61AFEF",
  RainbowOrange = "#D19A66",
  RainbowGreen  = "#98C379",
  RainbowViolet = "#C678DD",
  RainbowCyan   = "#56B6C2",
}

-- Register a hook to set highlights dynamically
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  for name, color in pairs(rainbow_colors) do
    vim.api.nvim_set_hl(0, name, { fg = color })
  end
end)

-- Setup IBL
ibl.setup({
  indent = {
    char = "┆",
    highlight = vim.tbl_keys(rainbow_colors),
  },
})
