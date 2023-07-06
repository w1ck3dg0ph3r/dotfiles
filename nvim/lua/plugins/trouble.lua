return {
  'folke/trouble.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons' },

  opts = {
    height = 16,
  },

  config = function(_, opts)
    require('trouble').setup(opts)

    local util = require('util')
    util.map('n', '<leader>xx', '<cmd>TroubleToggle<cr>')
    util.map('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>')
    util.map('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>')
    util.map('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>')
    util.map('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>')
    util.map('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>')
    util.map('n', 'gi', '<cmd>TroubleToggle lsp_implementations<cr>')
  end,
}
