-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Yank to system clipboard with <leader>y in normal and visual modes
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, desc = "Yank to system clipboard" })

-- File explorer (Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selected line(s) up or down in visual mode with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines but keep the cursor in place
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next/prev and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over selection without yanking
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Ctrl+C as Esc in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Open tmux-sessionizer (optional)
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format with Prettier (optional, or use LSP formatting)
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true })
end, { desc = "Format code" })

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Location list navigation
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Quickly open packer.lua (adjust path if using lazy.nvim)
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/tda/packer.lua<CR>")

-- Fun: CellularAutomaton make_it_rain
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- Source current file
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- Toggle comments (requires commentary or similar)
vim.keymap.set("n", "<leader>c", ":Commentary<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>c", ":Commentary<CR>", { noremap = true, silent = true })

-- Window navigation (minimal, using leader+lh/lj/ll/lk)
vim.keymap.set("n", "<leader>lh", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lj", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>lk", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ll", "<C-w>l", { noremap = true, silent = true })

-- New tab
vim.keymap.set("n", "<A-t>", function()
	vim.cmd("tabnew")
end, { noremap = true, silent = true })

-- Oil file explorer (if installed)
vim.keymap.set("n", "<C-n>", "<cmd>Oil<CR>", { desc = "Open Oil file explorer" })

-- Tab navigation
vim.keymap.set("n", "<A-n>", "<cmd>tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-p>", "<cmd>tabprevious<CR>", { noremap = true, silent = true })

-- TodoTelescope (if installed)
vim.keymap.set("n", "<Leader>tt", "<cmd>TodoTelescope<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>td", "<cmd>TodoLocList<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tq", "<cmd>TodoTelescope<CR>", { noremap = true, silent = true })

-- Redo
vim.api.nvim_set_keymap("n", "<S-u>", "<C-r>", { noremap = true, silent = true })

-- Rust: run code and cargo (if plugins installed)
vim.api.nvim_set_keymap("n", "<leader>rr", ":RustRun<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>rc", ":Cargo run<CR>", { noremap = true })

-- Show diagnostics float
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics float" })
