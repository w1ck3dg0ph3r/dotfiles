return {
  'folke/todo-comments.nvim',
  version = '1',

  dependencies = {
    'nvim-telescope/telescope.nvim',
  },

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    signs = true,
    keywords = {
      FIXME = { icon = ' ', color = 'error', alt = { 'FIX', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    },
  },

  config = function(_, opts)
    local todo = require('todo-comments')
    todo.setup(opts)

    -- Clean up some of the unused user comands.
    vim.api.nvim_del_user_command('TodoFzfLua')

    require('util').map('n', '<leader>sl', '<cmd>TodoTelescope<cr>')
  end,
}
