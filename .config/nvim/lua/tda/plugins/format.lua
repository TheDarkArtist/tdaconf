local conform = require("conform")

conform.setup({
	-- Map filetypes to formatters
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		python = { "black" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		markdown = { "prettier" },
		sh = { "shfmt" },
		-- add more as needed
	},

	-- Optional: Customize formatter args
	formatters = {
		prettier = {
			command = "prettier",
			args = {
				"--stdin-filepath",
				"$FILENAME",
				"--print-width",
				"80",
				"--trailing-comma",
				"es5",
				"--semi",
				"false",
				"--bracket-spacing",
				"true",
				"--arrow-parens",
				"always",
			},
		},
		stylua = {
			args = { "--search-parent-directories", "--stdin-filepath", "$FILENAME", "-" },
		},
		rustfmt = {},
		black = {},
		shfmt = {},
	},

	notify_on_error = true,
})
