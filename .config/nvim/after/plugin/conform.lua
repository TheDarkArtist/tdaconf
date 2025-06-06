local ok, conform = pcall(require, "conform")
if ok then
  conform.setup({
    format_on_save = false,
    formatters_by_ft = {
      python = { "black" },
      lua = { "stylua" },
      rust = { "rustfmt" },
      javascript = { "prettierd" },
      typescript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescriptreact = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      sh = { "shfmt" },
    },
  })

  -- Keybinding for manual formatting
  vim.keymap.set("n", "<leader>f", function()
    conform.format({ async = true })
  end)
end
