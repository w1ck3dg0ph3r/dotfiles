local M = {}

M.plugins = {
  { 'akinsho/bufferline.nvim',       enabled = false },
  { 'nvim-telescope/telescope.nvim', opts = { defaults = { file_ignore_patterns = { '^%.git/', '^vendor/' } } } },
  { 'nvim-tree/nvim-tree.lua',       opts = { filters = { custom = { '^\\.git$', '^vendor$' } } } },
}

M.lspconfig = {
  gopls = {
    settings = {
      gopls = {
        ['local'] = 'local.import/path',
        directoryFilters = { '-vendor' },
      },
    },
  }
}

return M
