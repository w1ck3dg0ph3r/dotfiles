return {
  'nvim-treesitter/nvim-treesitter',

  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },

  config = function()
    require('nvim-treesitter.install').update({ with_sync = true })

    local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'c',
        'cpp',
        'go',
        'lua',
        'python',
        'rust',
        'tsx',
        'typescript',
        'yaml',
        'vimdoc',
        'vim',
      },

      highlight = { enable = true },
      indent = { enable = true, disable = { 'python' } },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-e>',
        },
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['ic'] = '@class.inner',
            ['ac'] = '@class.outer',
            ['ib'] = '@block.inner',
            ['ab'] = '@block.outer',
          },
          selection_modes = {
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
            ['@block.outer'] = 'V',
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },
      },
    })

    -- Repeat movements
    vim.keymap.set({ 'n', 'x', 'o' }, ';', function()
      pcall(ts_repeat_move.repeat_last_move)
      vim.api.nvim_feedkeys('zz', 'n', false)
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', function()
      pcall(ts_repeat_move.repeat_last_move_opposite)
      vim.api.nvim_feedkeys('zz', 'n', false)
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
  end,
}
