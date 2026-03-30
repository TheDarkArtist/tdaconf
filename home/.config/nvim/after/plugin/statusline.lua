-- UPPERCASE mode indicator
vim.o.statusline = table.concat({
  " %<", -- Truncate long paths
  "%#StatusLine#",
  "%f ", -- File path
  "%m",  -- Modified [+]
  "%r",  -- Readonly
  "%=",  -- Right align
  "%{FugitiveHead() != '' ? ' ' . FugitiveHead() . ' ' : ''}", -- Git branch (Fugitive)
  "%y ", -- Filetype
  "%{&fileencoding?&fileencoding:&encoding} ", -- Encoding
  "%{&fileformat} ", -- File format (unix, dos, mac)
  "%#WarningMsg# %l:%c ", -- Line:Col
  "%p%% ", -- Progress
}, "")

