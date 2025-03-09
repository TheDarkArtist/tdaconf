local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Code action group
			vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })

			-- Inlay hints toggle
			vim.keymap.set("n", "<Leader>rh", rt.inlay_hints.enable, { buffer = bufnr, desc = "Toggle inlay hints" })

			-- Hover actions
			vim.keymap.set(
				"n",
				"<Leader>rh",
				rt.hover_actions.hover_actions,
				{ buffer = bufnr, desc = "Hover actions" }
			)

			-- Runnables (e.g., run a test or main function directly)
			vim.keymap.set("n", "<Leader>rrr", rt.runnables.runnables, { buffer = bufnr, desc = "Run Rust code" })
		end,
		settings = {
			["rust-analyzer"] = {
				inlayHints = {
					location = "right",
					typeHints = true,
					parameterHints = true,
				},
			},
		},
	},
	tools = {
		autoSetHints = true,
		inlay_hints = {
			show_parameter_hints = true,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			max_len_align = true,
		},
		hover_actions = {
			border = "rounded",
		},
	},
})
