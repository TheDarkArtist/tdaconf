vim.opt.guicursor = "v-c:block,i:ver25"

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = true
vim.opt.directory = os.getenv("HOME") .. "/.vim/swaps"
vim.opt.backup = true
vim.opt.backupdir = os.getenv("HOME") .. "/.vim/backups"
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- vim.g.loaded_netrwPlugin = 1

vim.cmd("highlight VertSplit guifg=#c0c0c0 guibg=NONE")
