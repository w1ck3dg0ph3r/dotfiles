return {
  'folke/trouble.nvim',
  version = '3',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

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
    util.map('n', '<leader>xx', '<cmd>Trouble close<cr>', { desc = 'Trouble: Close' })
    util.map('n', '<leader>xw', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Trouble: Workspace diagnostics' })
    util.map('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble: Buffer diagnostics' })
    util.map('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Trouble: Toggle loclist' })
    util.map('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Trouble: Toggle quickfix list' })
    util.map('n', 'gr', '<cmd>Trouble lsp_references open<cr>', { desc = 'LSP: Goto references' })
    util.map('n', 'gi', '<cmd>Trouble lsp_implementations open<cr>', { desc = 'LSP: Goto implementstions' }) -- Conflicts with built-in gi!
  end,
}
