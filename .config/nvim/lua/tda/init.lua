require("tda.set")
require("tda.remap")

local augroup = vim.api.nvim_create_augroup
local TheDarkArtistGroup = augroup('TheDarkArtist', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = TheDarkArtistGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.mkdp_echo_preview_url = 1

-- Enable Assembly Syntax Highlighting
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.asm",
  command = "set filetype=asm"
})

