return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
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
    vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>ss', builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set('n', '<leader>so', builtin.lsp_document_symbols, {})
    vim.keymap.set('n', '<leader>st', builtin.lsp_dynamic_workspace_symbols, {})
    vim.keymap.set('n', '<leader>sr', builtin.lsp_references, {})
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {})
  end,
}
