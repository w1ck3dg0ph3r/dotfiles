return {
  dir = '.',

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
