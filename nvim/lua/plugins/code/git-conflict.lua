local M = {
  'akinsho/git-conflict.nvim',
  version = '2',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    default_mappings = false,
    list_opener = 'copen',
  },

  ---@type function
  next_conflict = nil,
  ---@type function
  prev_conflict = nil,
}

function M.config(_, opts)
  local conflict = require('git-conflict')
  local util = require('util')

  conflict.setup(opts)

  if not opts.default_mappings then
    M.next_conflict, M.prev_conflict = util.make_repeatable_move(
      function() conflict.find_next('ours') end,
      function() conflict.find_prev('ours') end
    )

    local augr = vim.api.nvim_create_augroup('git-conflict', { clear = true })
    vim.api.nvim_create_autocmd('User', {
      group = augr,
      pattern = 'GitConflictDetected',
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        M.create_buffer_local_mappings(bufnr)
      end
    })
    vim.api.nvim_create_autocmd('User', {
      group = augr,
      pattern = 'GitConflictResolved',
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        M.clear_buffer_local_mappings(bufnr)
      end,
    })
  end
end

---Creates mappings for bufnr.
---@param bufnr integer
function M.create_buffer_local_mappings(bufnr)
  local util = require('util')
  local gc = require('git-conflict')
  util.map('n', 'co', function() gc.choose('ours') end, { buffer = bufnr })
  util.map('n', 'ct', function() gc.choose('theirs') end, { buffer = bufnr })
  util.map('n', 'c0', function() gc.choose('none') end, { buffer = bufnr })
  util.map('n', 'cb', function() gc.choose('both') end, { buffer = bufnr })
  util.map('n', ']x', M.next_conflict, { buffer = bufnr })
  util.map('n', '[x', M.prev_conflict, { buffer = bufnr })
end

---Clears mappings for bufnr.
---@param bufnr integer
function M.clear_buffer_local_mappings(bufnr)
  local util = require('util')
  util.delmap('n', 'co', { buffer = bufnr })
  util.delmap('n', 'ct', { buffer = bufnr })
  util.delmap('n', 'c0', { buffer = bufnr })
  util.delmap('n', 'cb', { buffer = bufnr })
  util.delmap('n', ']x', { buffer = bufnr })
  util.delmap('n', '[x', { buffer = bufnr })
end

return M
