-- Load Neovim-specific plugins
vim.fn.LoadPlugins(vim.g.config_dir .. '/plugins.nvim')

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { all },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = { enable = true },
}
