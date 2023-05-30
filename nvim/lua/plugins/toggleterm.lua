return {
  'akinsho/toggleterm.nvim',

  config = function()
    require('toggleterm').setup({
      open_mapping = [[<c-\>]],
      direction = 'horizontal',
      size = 16,
    })

    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<c-\><c-n>]], opts)
      vim.keymap.set('t', '<c-h>', [[<c-\><c-n><c-w>h]], opts)
      vim.keymap.set('t', '<c-j>', [[<c-\><c-n><c-w>j]], opts)
      vim.keymap.set('t', '<c-k>', [[<c-\><c-n><c-w>k]], opts)
      vim.keymap.set('t', '<c-l>', [[<c-\><c-n><c-w>l]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
