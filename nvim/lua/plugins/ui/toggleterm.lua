return {
  'akinsho/toggleterm.nvim',

  keys = { [[<c-\>]] },

  config = function()
    require('toggleterm').setup({
      open_mapping = [[<c-\>]],
      direction = 'horizontal',
      size = 16,
      persist_size = false,
    })
    local util = require('util')

    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      util.map('t', '<esc>', [[<c-\><c-n>]], opts)
      util.map('t', '<c-h>', [[<c-\><c-n><c-w>h]], opts)
      util.map('t', '<c-j>', [[<c-\><c-n><c-w>j]], opts)
      util.map('t', '<c-k>', [[<c-\><c-n><c-w>k]], opts)
      util.map('t', '<c-l>', [[<c-\><c-n><c-w>l]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
