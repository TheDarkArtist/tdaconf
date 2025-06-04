vim.o.statusline = table.concat({
  " %f ",         -- File path (relative)
  "%m",           -- Modified flag [+] if unsaved
  "%r",           -- Read-only flag
  "%=",           -- Aligns next items to right
  "%{&filetype} ",-- File type
  "%{&fileencoding?&fileencoding:&encoding} ", -- Encoding
  "%{&fileformat} ", -- File format (unix, dos, mac)
  "%{get(b:,'gitsigns_head','')} ", -- Git branch (if available)
  "%#WarningMsg# %l:%c ", -- Cursor position (line:column)
  "%p%% "         -- Progress percentage
}, "")

