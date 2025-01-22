local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

-- Configure nvim-tree
nvim_tree.setup({
  -- General settings
  disable_netrw = true,
  hijack_netrw = true,
  open_on_tab = true,
  hijack_cursor = false,
  update_cwd = true,

  -- Handle directories
  hijack_directories = {
    enable = true,
    auto_open = true,
  },

  -- Diagnostics settings
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  -- Sync with the focused file
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },

  -- System file opening
  system_open = {
    cmd = nil,
    args = {},
  },

  -- View settings
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = false,
  },

  -- Git integration
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },

  -- Renderer and UI icons (optional: Uncomment if needed)
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },

  -- File filters
  filters = {
    dotfiles = false,
    custom = {},
  },
})

