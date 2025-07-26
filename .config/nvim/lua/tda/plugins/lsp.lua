local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Keymaps
local function on_attach(_, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end

	-- Navigation - use Telescope if available, otherwise fallback
	local telescope = pcall(require, "telescope.builtin")
	if telescope then
		local tb = require("telescope.builtin")
		map("n", "gd", tb.lsp_definitions, "Go to Definition")
		map("n", "gi", tb.lsp_implementations, "Go to Implementation")
		map("n", "gr", tb.lsp_references, "Show References")
		map("n", "<leader>vws", tb.lsp_workspace_symbols, "Workspace Symbol")
	else
		map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
		map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
		map("n", "gr", vim.lsp.buf.references, "Show References")
		map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace Symbol")
	end

	-- Standard LSP keymaps
	map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
	map("n", "K", vim.lsp.buf.hover, "Hover")
	map("n", "<leader>vd", vim.diagnostic.open_float, "Line Diagnostics")
	map("n", "<leader>vca", vim.lsp.buf.code_action, "Code Action")
	map("n", "<leader>vrn", vim.lsp.buf.rename, "Rename")
	map("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, "Format")
	map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature Help")
	map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
	map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

-- Diagnostics
-- vim.diagnostic.config({
-- 	virtual_text = { prefix = "●" },
-- 	signs = true,
-- 	update_in_insert = false,
-- 	underline = true,
-- 	severity_sort = true,
-- 	float = { border = "rounded", source = "always" },
-- })

-- Floating window borders
local orig = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = "rounded"
	return orig(contents, syntax, opts, ...)
end

-- Server configs
local servers = {
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
				checkOnSave = { command = "clippy" },
			},
		},
	},
	ts_ls = {},
	pyright = {},
	gopls = {},
	tailwindcss = {},
	bashls = {},
}

-- Setup Mason if available
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
	mason.setup({})
	local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if mason_lsp_ok then
		mason_lspconfig.setup({
			automatic_installation = true,
			ensure_installed = vim.tbl_keys(servers),
			handlers = {
				function(server_name)
					local opts = {
						capabilities = capabilities,
						on_attach = on_attach,
					}
					if servers[server_name] then
						opts = vim.tbl_deep_extend("force", opts, servers[server_name])
					end
					lspconfig[server_name].setup(opts)
				end,
			},
		})
	end
else
	-- Fallback: setup servers manually
	for server, config in pairs(servers) do
		local opts = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
			on_attach = on_attach,
		}, config)
		lspconfig[server].setup(opts)
	end
end
