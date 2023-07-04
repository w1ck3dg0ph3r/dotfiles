return {
  dir = '.',
  name = 'languages/go',

  dependencies = {
    'akinsho/toggleterm.nvim',
    'L3MON4D3/LuaSnip',
  },

  ft = 'go',

  config = function()
    require('languages.go.snippets')
    require('languages.go.commands')
  end,
}
