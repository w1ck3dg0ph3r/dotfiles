require('config.lazy').bootstrap()

require('config.options')

local plugin_specs = require('config.lazy').load_plugin_specs()
require('config.nvimrc').extend_plugin_specs(plugin_specs)

require('lazy').setup({
  spec = {
    { 'Alighorab/stackmap.nvim' },
    vim.tbl_values(plugin_specs),
    require('custom.go'),
    require('custom.cpp'),
  },
  change_detection = { enabled = false },
})

require('config.keymaps')
require('config.autocmds')
