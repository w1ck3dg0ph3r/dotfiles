local toggleterm = require('toggleterm')
local ts_utils = require('nvim-treesitter.ts_utils')

local util = require('util')

local M = {}

M.run_package = '.'

vim.api.nvim_create_user_command('GoRun', function(opts)
  pcall(function() vim.cmd('wa') end)
  if opts.args ~= '' then
    M.run_package = opts.args
  end
  toggleterm.exec('go run ' .. M.run_package, 1, 0, nil, 'horizontal', 'go', true, true)
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
  toggleterm.exec(cmd, 1, 0, nil, 'horizontal', 'go', true, true)
end, {
  nargs = '?',
})

vim.api.nvim_create_user_command('GoTag', function(opts)
  local args = '-add-tags json -add-options json=omitempty'
  if opts.args ~= '' then
    args = opts.args
  end

  -- Find nearest struct outside the cursor
  local struct_node = ts_utils.get_node_at_cursor()
  if struct_node == nil then return end
  while struct_node ~= nil and struct_node:type() ~= 'type_declaration' do
    struct_node = struct_node:parent()
  end
  if struct_node == nil then return end
  local q = vim.treesitter.query.parse('go', [[
    (type_spec
      name: (type_identifier) @struct-name
      type: (struct_type)
    )
  ]])
  local struct_name
  ---@diagnostic disable-next-line: unused-local
  for id, node, metadata in q:iter_captures(struct_node, 0, 0, 0) do
    struct_name = vim.treesitter.get_node_text(node, 0)
    break
  end
  if struct_name == nil then return end

  -- Archive struct for gomodifytags
  local ns, _, ne, _ = struct_node:range()
  local lines = vim.api.nvim_buf_get_lines(0, ns, ne + 1, false)
  table.insert(lines, 1, '')
  table.insert(lines, 1, 'package _')
  local size = string.len(table.concat(lines, '\n'))
  table.insert(lines, 1, size)
  table.insert(lines, 1, '_.go')
  local archive = table.concat(lines, '\n')

  -- Pass dummy file to gomodifytags as an archive
  local cmd = table.concat({
    'gomodifytags -file _.go -modified',
    '-struct', struct_name,
    args,
  }, ' ')
  local out = vim.fn.systemlist(cmd, archive)
  if vim.v.shell_error ~= 0 then
    vim.notify('GoTag:\n' .. table.concat(out, '\n'))
    return
  end

  -- Remove package preamble
  table.remove(out, 1)
  table.remove(out, 1)
  -- Remove trailing empty line
  table.remove(out, #out)

  vim.api.nvim_buf_set_lines(0, ns, ns + #out, false, out)
end, {
  desc = 'Add tags to struct',
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
  local range_params = vim.lsp.util.make_range_params(0, "utf-8")
  local params = {
    range = range_params.range,
    textDocument = range_params.textDocument,
    context = { source = { organizeImports = true } },
  }

  local clients = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  if clients == nil then return end

  for _, result in pairs(clients) do
    if result.error ~= nil then
      print(result.error.message)
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
