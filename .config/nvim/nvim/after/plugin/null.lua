local null_ls = require("null-ls")

-- Define the sources for null-ls
local sources = {
  null_ls.builtins.formatting.prettier.with({
    filetypes = {
      "javascript",
      "typescript",
      "rust",
      "rs",
      "python",
      "html",
      "css",
      "json",
      "markdown",
      "yaml",
      "graphql",
      "pkgbuild",
      "toml",
      "c",
      "cpp",
      "xml",
      "svelte",
    },
  }),
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.clang_format,
  null_ls.builtins.formatting.black,
  null_ls.builtins.diagnostics.flake8,      -- Add Flake8 for Python
  null_ls.builtins.formatting.asmfmt,       -- Add asmfmt for assembly
  null_ls.builtins.formatting.markdownlint, -- Add Markdown formatting
}

null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})
