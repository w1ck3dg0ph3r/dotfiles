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

local lazy = require('lazy')
lazy.setup('plugins', {
  change_detection = { enabled = false },
})

require('settings')
require('keymap')

-- Include project specific config
pcall(dofile, vim.fn.getcwd() .. '/.nvimrc.lua')
