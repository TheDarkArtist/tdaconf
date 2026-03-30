local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
local yank_group = augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
	end,
})

-- Trim trailing whitespace on save
local tda_group = augroup("TheDarkArtist", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = tda_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Enable Assembly Syntax Highlighting
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.asm",
	command = "set filetype=asm",
})

vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cdd6f4", bg = "#1a1b26", bold = true }) -- Active: light fg, dark bg
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#6e738d", bg = "#16161e" }) -- Inactive: muted fg, slightly darker bg
