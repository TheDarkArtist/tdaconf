-- Safe require for lsp-zero
local ok_lsp, lsp = pcall(require, "lsp-zero")
if not ok_lsp then return end

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
end)

-- Mason setup
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
  mason.setup({})
end

local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if ok_mason_lspconfig then
  mason_lspconfig.setup({
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
      lsp.default_setup,

      lua_ls = function()
        local lua_opts = lsp.nvim_lua_ls()
        local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
        if ok_lspconfig then
          lspconfig.lua_ls.setup(lua_opts)
        end
      end,
    }
  })
end

-- Completion setup
local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then return end

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  completion = {
    autocomplete = false,
    completeopt = 'menu,menuone,noinsert',
  },
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
    ['<C-p>']     = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>']     = cmp.mapping.select_next_item(cmp_select),
    ['<CR>']      = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ['<C-y>']     = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>']     = cmp.mapping.abort(),
    ['<C-u>']     = cmp.mapping.scroll_docs(-4),
    ['<C-d>']     = cmp.mapping.scroll_docs(4),
  },

  snippet = {
    expand = function(args)
      local ok_luasnip, luasnip = pcall(require, "luasnip")
      if ok_luasnip then
        luasnip.lsp_expand(args.body)
      end
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
    hover = cmp.config.window.bordered(),
  },

  experimental = {
    ghost_text = false,
  },
})

-- Diagnostics config
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

vim.schedule(function()
  local orig_floating = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_floating(contents, syntax, opts, ...)
  end
end)
