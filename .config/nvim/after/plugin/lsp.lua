local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  -- Go to definition
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

  -- Show hover information
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

  -- Search workspace symbols
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

  -- Show diagnostics in floating window
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

  -- Show code actions
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

  -- Show references
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

  -- Rename symbol
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)

  -- Show signature help
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

  -- Format code
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end)

-- Mason setup
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'rust_analyzer',
    'lua_ls',
    'ts_ls',
    'pyright',
    'gopls',
    'tailwindcss',
    'bashls',
  },
  handlers = {
    -- Default setup for all servers
    lsp.default_setup,

    -- Custom setup for lua_ls
    lua_ls = function()
      local lua_opts = lsp.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

-- Completion setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  -- Auto-completion behavior
  completion = {
    autocomplete = false,
    completeopt = 'menu,menuone,noinsert', -- Auto-show menu, pre-select first item
  },

  -- Preselect first item
  preselect = cmp.PreselectMode.Item,

  sources = {
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip',  priority = 750 },
    { name = 'buffer',   priority = 500, keyword_length = 3 },
    { name = 'path',     priority = 250 },
    { name = 'nvim_lua' },
  },

  formatting = lsp.cmp_format({ details = true }),

  mapping = {
    -- Navigate completion items
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),

    -- Confirm selection
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true, -- Confirm even if no item is explicitly selected
    }),

    -- Alternative confirm (if you want both)
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),

    -- Manual completion trigger
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Cancel completion
    ['<C-e>'] = cmp.mapping.abort(),

    -- Scroll documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- Experimental features for better auto-completion
  experimental = {
    ghost_text = false, -- Set to true if you want to see ghost text
  },
})

-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Set up diagnostic signs
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
