return {
  dir = require('util').script_dir(),
  name = 'custom-go',
  ft = 'go',
  config = function()
    require('custom.go.snippets')
    require('custom.go.commands')
  end,
}
