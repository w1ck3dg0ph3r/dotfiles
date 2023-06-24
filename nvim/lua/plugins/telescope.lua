return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
  },

  keys = {
    '<leader>sc',
    '<leader>sb',
    '<leader>sh',
    '<leader>sf',
    '<leader>sg',
    '<leader>ss',
    '<leader>so',
    '<leader>st',
    '<leader>sr',
    '<leader>sd',
  },

  config = function()
    local util = require('util')
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<esc>'] = actions.close,
          },
        },
      },
    })

    local builtin = require('telescope.builtin')
    util.map('n', '<leader>sc', builtin.commands)
    util.map('n', '<leader>sb', builtin.buffers)
    util.map('n', '<leader>sh', builtin.help_tags)
    util.map('n', '<leader>sf', builtin.find_files, {})
    util.map('n', '<leader>sg', builtin.live_grep, {})
    util.map('n', '<leader>ss', builtin.current_buffer_fuzzy_find, {})
    util.map('n', '<leader>so', builtin.lsp_document_symbols, {})
    util.map('n', '<leader>st', builtin.lsp_dynamic_workspace_symbols, {})
    util.map('n', '<leader>sr', builtin.lsp_references, {})
    util.map('n', '<leader>sd', builtin.diagnostics, {})
  end,
}
