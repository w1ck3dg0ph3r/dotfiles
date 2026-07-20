return {
  dir = require('util').script_dir(),
  name = 'custom-go',
  ft = 'go',
  config = function()
    require('custom.go.snippets')
    require('custom.go.commands')

    vim.treesitter.query.set('go', 'textobjects',
      require('util').read_file(vim.fn.stdpath('config') .. '/lua/custom/go/textobjects.scm'))
  end,
}
