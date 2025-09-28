return {
  'stevearc/oil.nvim',
  version = '2',

  keys = { '-', '=' },

  config = function()
    local oil = require('oil')
    local util = require('util')

    oil.setup({
      columns = {
        -- 'type',
        'icon',
        -- 'permissions',
        -- 'size',
        -- 'mtime',
      },
      -- buf_options = {
      --   buflisted = true,
      --   bufhidden = '',
      -- },
      use_default_keymaps = false,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-p>'] = 'actions.preview',
        ['<leader>q'] = 'actions.close',
        ['gs'] = 'actions.change_sort',
        ['g.'] = 'actions.toggle_hidden',
      },
    })

    util.map('n', '-', oil.open)
    util.map('n', '=', function() oil.open(vim.fn.getcwd()) end)
  end,
}
