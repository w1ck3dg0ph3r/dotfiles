---@module 'lazy'

local M = {
  'stevearc/conform.nvim',
  version = '9',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },
}

---@param _ LazyPlugin
---@param opts conform.setupOpts
function M.config(_ --[[plugin--]], opts)
  local conform = require('conform')

  opts = {
    default_format_opts = {
      lsp_format = 'first',
    },
    formatters = {
      gci = {
        append_args = { '--custom-order', '-s', 'standard', '-s', 'default', '-s', 'localmodule', '-s', 'dot' },
      }
    },
    formatters_by_ft = {
      go = { 'goimports', 'gci', lsp_format = 'first' },
      json = { 'prettier' },
      yaml = { 'prettier' },
    },
    timeout_ms = 5000,
    format_on_save = function(buf)
      local autofmt = { 'go' }
      if not vim.tbl_contains(autofmt, vim.bo[buf].filetype) then
        return
      end
      return { timeout_ms = 3000 }
    end,
  }

  -- Apply conform from .nvimrc.lua
  local nvimrc = require('config.nvimrc').config()
  if nvimrc ~= nil and nvimrc.conform ~= nil then
    opts = vim.tbl_deep_extend('force', opts, nvimrc.conform)
  end

  conform.setup(opts)

  local util = require('util')
  util.map('n', '<leader>f', function() conform.format({ async = true }) end, { desc = 'Format file' })
  util.map('v', '<leader>f', function() conform.format({ async = true }) end, { desc = 'Format selection' })
end

return M
