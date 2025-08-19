local cmd = vim.api.nvim_create_user_command

-- Collapse multiple empty lines into exactly one
cmd("CleanEmptyLines", function()
  vim.cmd([[%s/\(\n\s*\)\{2,}/\r\r/g]])
end, {})

-- Trim trailing whitespace from all lines
cmd("TrimWhitespace", function()
  vim.cmd([[%s/\s\+$//e]])
end, {})

-- Reload current Lua module without restarting Neovim
cmd("ReloadModule", function(opts)
  local module = opts.args
  package.loaded[module] = nil
  require(module)
end, { nargs = 1, complete = "file" })

-- Copy full file path to system clipboard
cmd("CopyPath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Copied path: " .. path)
end, {})

-- Toggle spellcheck (e.g., for Markdown/docs)
cmd("ToggleSpell", function()
  vim.wo.spell = not vim.wo.spell
end, {})

-- Strip all comments from current file (e.g., code cleanup)
cmd("StripComments", function()
  vim.cmd([[g/^\s*--\|^\s*\/\//d]])
end, {})

-- List all TODO/FIXME/NOTE-style comments in project (requires ripgrep)
cmd("TodoList", function()
  vim.cmd([[vimgrep /TODO\|FIXME\|NOTE/ **/*]])
  vim.cmd("copen")
end, {})

-- Edit Vim config quickly
cmd("EditConfig", function()
  vim.cmd("edit $MYVIMRC")
end, {})

-- Reload Vim config (init.lua or init.vim)
cmd("ReloadConfig", function()
  vim.cmd("source $MYVIMRC")
  print("Reloaded vim config")
end, {})

-- Toggle search highlighting
cmd("ToggleHL", function()
  vim.o.hlsearch = not vim.o.hlsearch
end, {})

-- Convert tabs to spaces (respects expandtab settings)
cmd("TabsToSpaces", function()
  vim.cmd([[retab]])
end, {})

-- Remove duplicate lines in file (preserves first occurrence)
cmd("DedupLines", function()
  vim.cmd([[%!awk '!seen[$0]++']])
end, {})

-- View file statistics: lines, words, chars
cmd("FileStats", function()
  local stats = vim.fn.wordcount()
  print(string.format("Lines: %d | Words: %d | Chars: %d", stats["lines"], stats["words"], stats["chars"]))
end, {})

-- Print the absolute path of the current file
cmd("WhichFile", function()
  print(vim.fn.expand("%:p"))
end, {})

-- Yank entire buffer to system clipboard
cmd("YankAll", function()
  vim.cmd(":%y+")
  print("Buffer yanked to system clipboard")
end, {})

-- Close all hidden buffers (frees memory)
cmd("CloseHidden", function()
  vim.cmd([[silent! bufdo if !&modified && !&buflisted | bdelete | endif]])
end, {})
