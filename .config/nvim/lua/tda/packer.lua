vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- File Explorer and Navigation
	-- use({
	-- 	"nvim-tree/nvim-tree.lua", -- File explorer
	-- 	requires = {
	-- 		"nvim-tree/nvim-web-devicons", -- File icons for better visuals
	-- 	},
	-- })

	use({
		"stevearc/oil.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- Fuzzy Finder
	use({
		"nvim-telescope/telescope.nvim", -- Fuzzy finder for files, buffers, etc.
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- LSP and Autocompletion
	use({
		"VonHeikemen/lsp-zero.nvim", -- Easy setup for LSP
		branch = "v1.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- LSP configuration
			{ "williamboman/mason.nvim" }, -- LSP installer
			{ "williamboman/mason-lspconfig.nvim" }, -- Mason integration with LSPconfig

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Completion engine
			{ "hrsh7th/cmp-buffer" }, -- Buffer completions
			{ "hrsh7th/cmp-path" }, -- Path completions
			{ "saadparwaiz1/cmp_luasnip" }, -- Snippet completions
			{ "hrsh7th/cmp-nvim-lsp" }, -- LSP completions
			{ "hrsh7th/cmp-nvim-lua" }, -- Neovim Lua API completions

			-- Snippets
			{ "L3MON4D3/LuaSnip" }, -- Snippet engine
			{ "rafamadriz/friendly-snippets" }, -- Predefined snippets
		},
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter", -- Syntax highlighting and parsing
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- use("nvim-treesitter/nvim-treesitter-context") -- Context-based highlighting

	-- Refactoring Tools
	-- use("theprimeagen/refactoring.nvim") -- Refactoring utilities

	-- Git Integration
	-- use("tpope/vim-fugitive") -- Git commands within Neovim

	-- Trouble List
	-- use("folke/trouble.nvim") -- Pretty diagnostics list

	-- Status Line
	-- use({
	--   "nvim-lualine/lualine.nvim",                              -- Status line plugin
	--   requires = { "nvim-tree/nvim-web-devicons", opt = true }, -- Icons for lualine
	-- })

	-- Formatting and Linting
	-- use("jose-elias-alvarez/null-ls.nvim") -- External tool integration (e.g., formatters, linters)

	-- Theme
	use("EdenEast/nightfox.nvim") -- Theme for Neovim

	-- Markdown Support
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_echo_preview_url = 1
		end,
		ft = { "markdown" },
	})

	-- Distraction-free Writing
	-- use("junegunn/goyo.vim") -- Focus mode for writing

	-- Assembly Syntax Highlighting
	use("Shirk/vim-gas") -- GNU Assembly syntax support

	-- Code Formatting
	use("MunifTanjim/prettier.nvim") -- Prettier integration for code formatting

	-- Indentation Visualization
	use("lukas-reineke/indent-blankline.nvim") -- Indentation guides

	-- Code Commenting
	use("tpope/vim-commentary") -- Easily comment lines

	-- Flutter Development
	-- use({
	-- 	"akinsho/flutter-tools.nvim", -- Flutter support
	-- 	requires = "nvim-lua/plenary.nvim",
	-- })

	-- Undo Tree
	-- use("mbbill/undotree") -- Visualize undo history

	-- Auto-pairing
	use({
		"windwp/nvim-autopairs", -- Auto-close brackets, quotes, etc.
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- Comment Visualization
	-- use({
	-- 	"folke/todo-comments.nvim", -- Highlight TODO, NOTE, etc. comments
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- })

	-- Multi-cursor Support
	-- This one is the best, but needs remapping which I can't figure out for now.
	-- use({ "mg979/vim-visual-multi", branch = "master" })

	-- Cloak sensitive information in files
	-- use("laytan/cloak.nvim") -- Hide sensitive information (e.g., API keys)

	-- github themes
	--	use("projekt0n/github-nvim-theme")

	-- use("simrat39/rust-tools.nvim")

	-- use("github/copilot.vim")

	-- use("Exafunction/codeium.vim")

	use("stevearc/conform.nvim")
end)
