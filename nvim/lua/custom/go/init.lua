return {
  dir = vim.fn.stdpath('config') .. '/lua/custom/go',
  name = 'custom-go',
  dependencies = {
    'akinsho/toggleterm.nvim',
    'L3MON4D3/LuaSnip',
  },
  ft = 'go',
  config = function()
    require('custom.go.snippets')
    require('custom.go.commands')
  end,
}
