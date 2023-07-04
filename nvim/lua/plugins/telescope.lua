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

  opts = {
    defaults = {
      mappings = {
        i = {
          ['<esc>'] = 'close',
        },
      },
    },
  },

  config = function(_, opts)
    local util = require('util')
    local themes = require('telescope.themes')

    -- Open in trouble instead of quickfix
    local has_trouble, trouble = pcall(require, 'trouble.providers.telescope')
    if has_trouble then
      opts.defaults.mappings.i['<c-q>'] = trouble.open_with_trouble
    end

    require('telescope').setup(opts)

    local builtin = require('telescope.builtin')
    util.map('n', '<leader>sc', function() builtin.commands(themes.get_dropdown()) end)
    util.map('n', '<leader>sb', function() builtin.buffers(themes.get_dropdown()) end)
    util.map('n', '<leader>sh', builtin.help_tags)
    util.map('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end)
    util.map('n', '<leader>sg', builtin.live_grep)
    util.map('n', '<leader>ss', builtin.current_buffer_fuzzy_find)
    util.map('n', '<leader>so', builtin.lsp_document_symbols)
    util.map('n', '<leader>st', builtin.lsp_dynamic_workspace_symbols)
    util.map('n', '<leader>sr', builtin.lsp_references)
    util.map('n', '<leader>si', builtin.lsp_implementations)
    util.map('n', '<leader>sd', builtin.diagnostics)
  end,
}
