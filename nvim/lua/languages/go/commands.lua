local toggleterm = require("toggleterm")
local util = require('util')

local M = {
  last_run_package = '.',
}

vim.api.nvim_create_user_command('GoRun', function(opts)
  vim.cmd('w')
  if opts.args ~= '' then
    M.last_run_package = opts.args
  end
  toggleterm.exec('go run ' .. M.last_run_package, 1, 0, nil, 'horizontal', true)
end, {
  nargs = '?',
})
util.map('n', '<f9>', '<cmd>GoRun<cr>')

vim.api.nvim_create_user_command('GoTest', function(opts)
  toggleterm.exec('go test . -v', 1, 0, nil, 'horizontal', true)
end, {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(ev)
    local group = vim.api.nvim_create_augroup('format_on_save', { clear = true })

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = group,
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format()
        M.go_organize_imports()
      end,
    })
  end,
})

M.go_organize_imports = function()
  local context = { source = { organizeImports = true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  if not result then return end
  result = result[1].result
  if not result then return end
  vim.lsp.util.apply_workspace_edit(result[1].edit, 'utf-8')
end

return M
