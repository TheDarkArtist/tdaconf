-- lua/oil.lua

-- Ensure oil.nvim is required and configured
local ok, oil = pcall(require, "oil")
if not ok then
	vim.notify("oil.nvim not found!", vim.log.levels.ERROR)
	return
end

oil.setup({
	default_file_explorer = true, -- override netrw
	delete_to_trash = false, -- disable trash-cli
	skip_confirm_for_simple_edits = true,
	columns = {
		"icon", -- File icon (requires web-devicons)
		"permissions", -- rwxr-xr-x
		"size", -- human-readable size
		"mtime", -- last modified
	},
	view_options = {
		show_hidden = true,
	},
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-s>"] = "actions.select_split",
		["<C-v>"] = "actions.select_vsplit",
		["<C-t>"] = "actions.select_tab",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
	},
})
