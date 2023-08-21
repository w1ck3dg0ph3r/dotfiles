local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('settings')
require('keymap')

-- Load plugin specs and extend them with nvimrc ones
local plugins = require('util').load_plugins()
local nvimrc = require('nvimrc').config()
if nvimrc ~= nil and nvimrc.plugins ~= nil then
  for _, spec in pairs(nvimrc.plugins) do
    if spec[1] ~= nil and type(spec[1]) == 'string' then
      local name = spec[1]
      plugins[name] = vim.tbl_deep_extend('force', plugins[name], spec)
    end
  end
end

local lazy = require('lazy')
lazy.setup(
  {
    vim.tbl_values(plugins),
    { import = 'languages' },
  },
  {
    change_detection = { enabled = false },
  }
)
