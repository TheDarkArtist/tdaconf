-- Set leader key to space
vim.g.mapleader = " "

-- Quick access to the file explorer using <leader>pv
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selected line(s) up or down in visual mode with J/K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move up

-- Join lines but keep the cursor in place
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll down and center the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Scroll up and center the screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next occurrence and center the screen
vim.keymap.set("n", "n", "nzzzv")

-- Search previous occurrence and center the screen
vim.keymap.set("n", "N", "Nzzzv")

-- Start and stop a collaborative editing session with Vim-With-Me
vim.keymap.set("n", "<leader>vwm", function()
  require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
  require("vim-with-me").StopVimWithMe()
end)

-- Remap to paste over selected text without overwriting the default register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Remap for copying to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y') -- Copy to clipboard in normal/visual mode
vim.keymap.set("n", "<leader>Y", '"+Y')          -- Copy the entire line to clipboard in normal mode

-- Remap for deleting text without overwriting the default register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Use Ctrl+C as an alternative to Esc in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable the ex mode key (Q)
vim.keymap.set("n", "Q", "<nop>")

-- Open a new tmux window with tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format code using Prettier
vim.keymap.set("n", "<leader>f", ":Prettier<CR>", { noremap = true, silent = true })

-- Navigate through quickfix list with Ctrl-k/Ctrl-j
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Navigate through location list with <leader>k/j
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search and replace the word under the cursor in the whole file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Quickly open packer.lua for plugin management
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/tda/packer.lua<CR>")

-- Fun command to make it rain (CellularAutomaton plugin)
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- Source the current file
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)

-- Toggle comments in normal and visual mode
vim.api.nvim_set_keymap("n", "<leader>c", ":Commentary<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>c", ":Commentary<CR>", { noremap = true, silent = true })

-- Split window commands: i don't think i need them
-- vim.keymap.set("n", "<C-v>", "<cmd>vsplit<CR>", { noremap = true, silent = true }) -- Vertical split
-- vim.keymap.set("n", "<C-h>", "<cmd>split<CR>", { noremap = true, silent = true })  -- Horizontal split

-- Remap for navigating between windows
vim.keymap.set("n", "<leader>lh", "<C-w>h", { noremap = true, silent = true }) -- Move to the left window
vim.keymap.set("n", "<leader>lj", "<C-w>j", { noremap = true, silent = true }) -- Move to the bottom window
vim.keymap.set("n", "<leader>lk", "<C-w>k", { noremap = true, silent = true }) -- Move to the top window
vim.keymap.set("n", "<leader>ll", "<C-w>l", { noremap = true, silent = true }) -- Move to the right window

-- Open a new tab and start Nvim-Tree
vim.keymap.set("n", "<A-t>", function()
  vim.cmd("tabnew") -- Open a new tab
end, { noremap = true, silent = true })

vim.keymap.set("n", "<C-n>", "<cmd>Oil<CR>", { desc = "Open Oil file explorer" })

-- Switch between tabs with Alt+n/p
vim.keymap.set("n", "<A-n>", "<cmd>tabnext<CR>", { noremap = true, silent = true })     -- Go to next tab
vim.keymap.set("n", "<A-p>", "<cmd>tabprevious<CR>", { noremap = true, silent = true }) -- Go to previous tab

-- TodoTelescope key mappings
vim.keymap.set("n", "<Leader>tt", "<cmd>TodoTelescope<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>td", "<cmd>TodoLocList<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>tq", "<cmd>TodoTelescope<CR>", { noremap = true, silent = true })

-- Nvim-Tree key mappings
-- vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-n>", "<cmd>Oil<CR>", { desc = "Open Oil file explorer" })

-- Redo
vim.api.nvim_set_keymap("n", "<S-u>", "<C-r>", { noremap = true, silent = true })

-- Run standalone rust code
vim.api.nvim_set_keymap("n", "<leader>rr", ":RustRun<CR>", { noremap = true })

-- Run cargo
vim.api.nvim_set_keymap("n", "<leader>rc", ":Cargo run<CR>", { noremap = true })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics float" })
