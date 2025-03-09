local null_ls = require("null-ls")

-- Define the sources for null-ls
local sources = {
	null_ls.builtins.formatting.prettier.with({
		filetypes = {
			"javascript",
			"typescript",
			"python",
			"html",
			"css",
			"json",
			"markdown",
			"yaml",
			"graphql",
			"pkgbuild",
			"toml",
			"c",
			"cpp",
			"xml",
			"svelte",
		},
	}),
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.rustfmt,
	null_ls.builtins.formatting.clang_format,
	null_ls.builtins.formatting.black,
	null_ls.builtins.diagnostics.flake8,
	null_ls.builtins.formatting.asmfmt,
	null_ls.builtins.formatting.markdownlint,
}

null_ls.setup({
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
			end, { buffer = bufnr, desc = "[lsp] format" })
		end

		if client.supports_method("textDocument/rangeFormatting") then
			vim.keymap.set("x", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
			end, { buffer = bufnr, desc = "[lsp] format" })
		end
	end,
})
