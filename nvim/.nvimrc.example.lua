---@module 'config.nvimrc'

---@type nvimrc.Config
local cfg = {}

cfg.plugins = {
  { 'nvim-telescope/telescope.nvim', opts = { defaults = { file_ignore_patterns = { '^%.git/', '^vendor/' } } } },
}

cfg.lspconfig = {
  gopls = {
    settings = {
      gopls = {
        ['local'] = 'local.import/path',
        directoryFilters = { '-vendor' },
      },
    },
  }
}

cfg.go = {
  test = {
    coverage_enabled = true,
    coverage_file = 'coverage.out',
  },
}

cfg.conform = {
  formatters_by_ft = {
    go = { 'goimports', 'golangci-lint', lsp_format = 'first' }
  },
}

return cfg
