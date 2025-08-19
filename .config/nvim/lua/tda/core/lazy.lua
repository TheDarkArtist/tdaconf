-- ~/.config/nvim/lua/tda/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- File Explorer
	{ "stevearc/oil.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Fuzzy Finder
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- LSP and Autocompletion
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", lazy = false },
	{ "williamboman/mason-lspconfig.nvim", lazy = false },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "L3MON4D3/LuaSnip" },
	{ "rafamadriz/friendly-snippets" },

	-- Treesitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Git Integration
	{ "tpope/vim-fugitive" },

	-- Theme
	{ "EdenEast/nightfox.nvim" },

	-- Markdown Support
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown" },
		config = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_echo_preview_url = 1
		end,
	},

	-- Assembly Syntax Highlighting
	{ "Shirk/vim-gas" },

	-- Code Formatting
	{ "MunifTanjim/prettier.nvim" },
	{ "stevearc/conform.nvim" },

	-- Indentation Visualization
	{ "lukas-reineke/indent-blankline.nvim" },

	-- Code Commenting
	{ "tpope/vim-commentary" },

	-- Auto-pairing
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{
		"augmentcode/augment.vim",
	},
})
