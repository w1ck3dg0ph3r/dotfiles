return {
  'folke/trouble.nvim',
  version = '3',

  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  opts = {
    focus = true,
    auto_jump = true,
    auto_refresh = false,
    win = {
      type = 'split',
      position = 'bottom',
      size = 16,
    },
  },

  config = function(_, opts)
    require('trouble').setup(opts)

    local util = require('util')
    util.map('n', '<leader>xx', '<cmd>Trouble close<cr>')
    util.map('n', '<leader>xw', '<cmd>Trouble diagnostics toggle<cr>')
    util.map('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>')
    util.map('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>')
    util.map('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>')
    util.map('n', 'gr', '<cmd>Trouble lsp_references open<cr>')
    util.map('n', 'gi', '<cmd>Trouble lsp_implementations open<cr>')
  end,
}
