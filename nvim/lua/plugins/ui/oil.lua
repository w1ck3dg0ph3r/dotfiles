return {
  'stevearc/oil.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons' },

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
        ['q'] = 'actions.close',
        ['gs'] = 'actions.change_sort',
        ['g.'] = 'actions.toggle_hidden',
      },
    })

    util.map('n', '-', '<cmd>Oil<cr>')
  end,
}
