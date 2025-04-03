require("conform").setup({
	format_on_save = {
		async = true,
		timeout_ms = 2000,
	},
	formatters_by_ft = {
		python = { "black" },
		lua = { "stylua" },
		rust = { "rustfmt" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		sh = { "shfmt" },
	},
})

-- Keybinding for manual formatting
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true })
end)
