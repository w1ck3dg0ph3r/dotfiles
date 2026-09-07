local M = {
  dir = require('util').script_dir(),
  name = 'custom-odin',
  ft = 'odin',
  opts = {},
}

local helper_script = require('util').script_dir() .. '/odin.py'

function M.config(plugin, opts)
  vim.print('odin setup')

  --TODO: Check if we have ols available first.
  vim.lsp.enable('ols')

  local dap = require('dap')
  dap.configurations.odin = {
    {
      name = 'Odin: Package',
      type = 'codelldb',
      request = 'launch',
      program = function()
        local package = vim.fn.input({
          prompt = 'Package: ',
          default = 'src',
        })
        vim.fn.system('odin build ' .. package .. ' -out:debug -debug')
        return '${workspaceFolder}/debug'
      end,
      cwd = '${workspaceFolder}',
      initCommands = function()
        return { 'command script import ' .. helper_script }
      end,
    },
  }
end

return M
