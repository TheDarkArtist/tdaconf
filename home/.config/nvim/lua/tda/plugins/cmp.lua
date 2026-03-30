local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then return end

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  completion = {
    autocomplete = false, -- Only manual trigger
    completeopt = "menu,menuone,noinsert",
  },
  preselect = cmp.PreselectMode.Item,
  sources = {
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip",  priority = 750 },
    { name = "buffer",   priority = 500, keyword_length = 3 },
    { name = "path",     priority = 250 },
    { name = "nvim_lua" },
  },
  mapping = {
    ["<C-p>"]     = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"]     = cmp.mapping.select_next_item(cmp_select),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-y>"]     = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(), -- Manual trigger
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-d>"]     = cmp.mapping.scroll_docs(4),
  },
  snippet = {
    expand = function(args)
      local ok, luasnip = pcall(require, "luasnip")
      if ok then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = { ghost_text = false },
})
