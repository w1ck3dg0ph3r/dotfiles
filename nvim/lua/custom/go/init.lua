return {
  dir = require('util').script_dir(),
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
