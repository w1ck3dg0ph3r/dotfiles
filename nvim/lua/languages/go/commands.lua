local toggleterm = require('toggleterm')
local util = require('util')

local M = {}

M.run_package = '.'

vim.api.nvim_create_user_command('GoRun', function(opts)
  pcall(function() vim.cmd('wa') end)
  if opts.args ~= '' then
    M.run_package = opts.args
  end
  toggleterm.exec('go run ' .. M.run_package, 1, 0, nil, 'horizontal', true)
end, {
  nargs = '?',
})
util.map('n', '<f9>', '<cmd>GoRun<cr>')

vim.api.nvim_create_user_command('GoTest', function(opts)
  pcall(function() vim.cmd('wa') end)
  local cmd = 'go test ./...'
  if opts.args ~= '' then
    cmd = cmd .. ' -run ' .. opts.args
  end
  cmd = cmd .. ' -v'
  toggleterm.exec(cmd, 1, 0, nil, 'horizontal', true)
end, {
  nargs = '?',
})

local augroup = vim.api.nvim_create_augroup('format_on_save', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'go' then
      M.go_organize_imports()
      vim.lsp.buf.format()
    end
  end,
})

M.go_organize_imports = function()
  local context = { source = { organizeImports = true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context

  local clients = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  if clients == nil then return end

  for _, result in pairs(clients) do
    if result.err ~= nil then
      print(result.err.message)
      return
    end
    if result.result == nil then
      return
    end
    for _, edit in ipairs(result.result) do
      if edit.kind == 'source.organizeImports' then
        vim.lsp.util.apply_workspace_edit(edit.edit, 'utf-8')
      end
    end
  end
end

return M
