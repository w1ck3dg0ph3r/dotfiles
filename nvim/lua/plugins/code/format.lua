---@module 'lazy'

local M = {
  'stevearc/conform.nvim',
  version = '9',

  dependencies = {
    { 'nvimtools/none-ls.nvim', branch = 'main' },
  },

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },
}

---@param _ LazyPlugin
---@param opts conform.setupOpts
function M.config(_ --[[plugin--]], opts)
  local nullls = require('null-ls')
  nullls.setup({
    timeout_ms = 5000,
    sources = {
      nullls.builtins.formatting.prettier,
      nullls.builtins.formatting.black,
      nullls.builtins.formatting.isort,
    },
  })

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
      go = { 'goimports', 'gci', lsp_format = 'first' }
    },
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
  util.map({ 'n', 'v' }, '<leader>f', M.format)
end

local filter_lsp_formatter

function M.format()
  local ft = vim.bo[vim.api.nvim_get_current_buf()].filetype
  local has_null_ls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0

  require('conform').format({
    async = true,
    filter = filter_lsp_formatter(has_null_ls),
  })
end

---Filters lsp clients for formatting.
---@param nullls boolean If true allow only null-ls, else allow other LSPs
---@return fun(client: table): boolean filter Filter function for vim.lsp.buf.format()
filter_lsp_formatter = function(nullls)
  if nullls then
    return function(client) return client.name == 'null-ls' end
  else
    return function(client) return client.name ~= 'null-ls' end
  end
end

return M
