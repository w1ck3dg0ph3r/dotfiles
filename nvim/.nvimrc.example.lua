local M = {}

M.plugins = {
  { 'akinsho/bufferline.nvim', enabled = false },
  {
    'nvim-telescope/telescope.nvim',
    opts = {
      defaults = {
        file_ignore_patterns = { 'vendor' }
      },
    }
  },
}

M.lspconfig = {
  gopls = {
    gopls = {
      ['local'] = 'local.import/path',
      directoryFilters = { '-vendor' },
    },
  }
}

return M
