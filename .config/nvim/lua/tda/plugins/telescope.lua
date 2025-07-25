local ok, builtin = pcall(require, "telescope.builtin")
if not ok then
	return
end

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep: ") })
end)
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
