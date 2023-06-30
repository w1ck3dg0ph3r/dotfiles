local M = {}

local telescope = require('telescope')
telescope.setup({
  defaults = {
    file_ignore_patterns = { 'vendor' },
  },
})

M.lspconfig = {
  gopls = {
    gopls = {
      ['local'] = 'importpath.local',
      directoryFilters = { '-vendor' },
    },
  }
}

return M
