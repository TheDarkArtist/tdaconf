-- Ensure oil.nvim is required and configured
local ok, oil = pcall(require, "oil")
if not ok then
  vim.notify("oil.nvim not found!", vim.log.levels.ERROR)
  return
end

oil.setup({
  default_file_explorer = true, -- override netrw
  delete_to_trash = false,
  skip_confirm_for_simple_edits = true,
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["F5"] = "actions.refresh",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-t>"] = "actions.select_tab",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
  },
})

-- Keymap to open Oil (file explorer)
vim.keymap.set("n", "<C-n>", "<cmd>Oil<CR>", { desc = "Open Oil file explorer" })

