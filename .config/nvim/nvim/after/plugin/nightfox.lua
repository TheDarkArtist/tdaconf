require("nightfox").setup({
  options = {
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled",
    transparent = true,
    terminal_colors = true,
    dim_inactive = false, -- Visually separates focused vs unfocused panes
    module_default = true,

    colorblind = {
      enable = false,
      simulate_only = false,
      severity = {
        protan = 0,
        deutan = 0,
        tritan = 0,
      },
    },

    -- styles = {
    comments = "italic",
    -- 	conditionals = "italic",
    -- 	constants = "bold",
    -- 	functions = "italic,bold",
    -- 	keywords = "bold",
    -- 	numbers = "NONE",
    -- 	operators = "NONE",
    -- 	strings = "NONE",
    -- 	types = "italic",
    -- 	variables = "NONE",
    -- },

    inverse = {
      match_paren = false, -- Helps visual matching
      visual = false,
      search = true,       -- Makes search stand out clearly
    },

    modules = {
      cmp = true,
      diagnostic = true,
      native_lsp = true,
      treesitter = true,
      telescope = true,
      whichkey = true,
      gitsigns = true,
      lsp_trouble = true,
      indent_blankline = true,
      neotree = true,
      nvimtree = true,
    },
  },

  groups = {
    all = {
      -- Sharpened UI contrast
      VertSplit = { fg = "#cccccc", bg = "NONE" },
      NormalFloat = { link = "Normal" },
      FloatBorder = { fg = "palette.fg3", bg = "palette.bg1" },
      Pmenu = { fg = "palette.fg1", bg = "palette.bg1" },
      PmenuSel = { fg = "palette.fg0", bg = "palette.bg3", style = "bold" },
      CursorLine = { bg = "palette.bg2" },
      CursorLineNr = { fg = "palette.orange", style = "bold" },
      StatusLine = { fg = "palette.fg2", bg = "palette.bg1" },
      Visual = { bg = "palette.bg3" },

      -- Diagnostics
      DiagnosticError = { fg = "#ff5c57", style = "italic" },
      DiagnosticWarn = { fg = "#f3f99d", style = "italic" },
      DiagnosticInfo = { fg = "#57c7ff" },
      DiagnosticHint = { fg = "#9aedfe" },
    },
  },

  palettes = {},
  specs = {},
})

vim.cmd("colorscheme carbonfox")
