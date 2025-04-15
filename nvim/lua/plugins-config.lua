-- Load Neovim-specific plugins
vim.fn.LoadPlugins(vim.g.config_dir .. '/plugins.nvim')

-- Use Neovim-specific colorscheme
require 'onedark'.setup {
  transparent = true,
  ending_tildes = true,

  -- Don't show comments in italics
  code_style = {
    comments = 'none',
  },

  -- Custom tokens highlights
  highlights = {
    ['@comment.todo'] = { fg = '$purple' },
    ['@string.escape'] = { fg = '$cyan' },
    ['@type.builtin'] = { fg = '$yellow' },
    ['@variable.member'] = { fg = '$fg' },
    ['@field'] = { fg = '$red' },
    ['@function.builtin'] = { fg = '$blue' },
    ['@property'] = { fg = '$red' },
    ['@operator'] = { fg = '$purple' },
  }
}
require 'onedark'.load()

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { 'comment' },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = { enable = true },
}
