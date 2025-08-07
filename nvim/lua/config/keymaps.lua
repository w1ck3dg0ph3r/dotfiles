local M = {}

function M.setup()
  local util = require('util')

  -- Escape insert mode quickly
  util.map('i', 'jk', '<esc>')
  util.map('i', '<c-c>', '<esc>')

  -- Clear search highlighting with <leader> and c
  util.map('n', '<leader>c', '<cmd>nohl<cr>')

  -- Fast saving with <leader> and s
  util.map('n', '<leader>s', '<cmd>w<cr>')

  -- Fast quitting with <leader> and q/sq
  util.map('n', '<leader>q', '<cmd>q<cr>')
  util.map('n', '<leader>sq', '<cmd>x<cr>')

  -- Use leader + d/c to cut, d and x to delete
  util.map({ 'n', 'v' }, 'd', '"_d')
  util.map({ 'n', 'v' }, 'D', '"_D')
  util.map({ 'n', 'v' }, 'x', '"_x')
  util.map({ 'n', 'v' }, 'X', '"_X')
  util.map({ 'n', 'v' }, 'c', '"_c')
  util.map({ 'n', 'v' }, 'C', '"_C')
  util.map({ 'n', 'v' }, '<leader>d', 'd')
  util.map({ 'n', 'v' }, '<leader>D', 'D')

  -- Indent stay in visual mode
  util.map('v', '<', '<gv')
  util.map('v', '>', '>gv')
  -- Indent using single brackets
  util.map('n', '<', '<<')
  util.map('n', '>', '>>')

  -- Make paste in visual mode not yank replaced text
  util.map('v', 'p', 'P')

  -- Move around splits using Ctrl + {h,j,k,l}
  util.map('n', '<c-h>', '<c-w>h')
  util.map('n', '<c-j>', '<c-w>j')
  util.map('n', '<c-k>', '<c-w>k')
  util.map('n', '<c-l>', '<c-w>l')

  -- Buffers
  util.map('n', '<a-h>', '<cmd>bp<cr>')
  util.map('n', '<a-g>', '<cmd>b#<cr>')
  util.map('n', '<a-l>', '<cmd>bn<cr>')
  util.map('n', '<leader>w', M.delete_buffer)
  util.map('n', '<leader>o', M.delete_other_buffers)

  -- Move lines around
  util.map('n', '<a-j>', '<cmd>m .+1<cr>==')
  util.map('n', '<a-k>', '<cmd>m .-2<cr>==')
  util.map('i', '<a-j>', '<esc><cmd>m .+1<cr>==gi')
  util.map('i', '<a-k>', '<esc><cmd>m .-2<cr>==gi')
  util.map('v', '<a-j>', ':m \'>+1<cr>gv=gv')
  util.map('v', '<a-k>', ':m \'<-2<cr>gv=gv')

  -- Keep jumps when navigating
  util.map('n', '{', '<cmd>keepjumps norm! {<cr>')
  util.map('n', '}', '<cmd>keepjumps norm! }<cr>')
  util.map('n', '(', '<cmd>keepjumps norm! (<cr>')
  util.map('n', ')', '<cmd>keepjumps norm! )<cr>')

  -- Add jumps when j/k >= 5 lines
  local mark_if_count = function(count) return (count >= 5 and 'm\'' .. count or '') end
  util.map('n', 'j', function() return mark_if_count(vim.v.count) .. 'j' end, { expr = true })
  util.map('n', 'k', function() return mark_if_count(vim.v.count) .. 'k' end, { expr = true })

  -- Diagnostics
  local next_diagnostic, prev_diagnostic = util.make_repeatable_move(
    function() vim.diagnostic.jump({ count = 1 }) end,
    function() vim.diagnostic.jump({ count = -1 }) end
  )
  util.map('n', ']d', next_diagnostic)
  util.map('n', '[d', prev_diagnostic)
  util.map('n', '<leader>df', vim.diagnostic.open_float)
  util.map('n', '<leader>dl', vim.diagnostic.setloclist)

  -- Folds
  local next_fold, prev_fold = util.make_repeatable_move('zj', 'zk')
  util.map('n', ']z', next_fold)
  util.map('n', '[z', prev_fold)

  -- Spelling
  local next_spell, prev_spell = util.make_repeatable_move(']s', '[s')
  util.map('n', ']s', next_spell)
  util.map('n', '[s', prev_spell)

  -- Changes
  local next_change, prev_change = util.make_repeatable_move(']c', '[c')
  util.map('n', ']c', next_change)
  util.map('n', '[c', prev_change)

  -- LSP hover and DAP eval
  util.map('n', 'K', M.symbol_hover, { silent = true })
end

---Delete current buffer, preserving window if there are other buffers present.
function M.delete_buffer()
  if not M.buf_loaded_n_listed(vim.api.nvim_get_current_buf()) then
    vim.cmd('q')
    return
  end

  local bufs = vim.tbl_filter(M.buf_loaded_n_listed, vim.api.nvim_list_bufs())
  local wins = vim.api.nvim_list_wins()

  if #wins == 1 then
    if #bufs == 1 then
      vim.cmd('q')
    else
      vim.cmd('bd')
    end
  else
    if #bufs == 1 then
      vim.cmd('qa')
    else
      vim.cmd('bp')
      vim.cmd('bd#')
    end
  end
end

---Deletes all buffers not visible in windows on a current tab.
function M.delete_other_buffers()
  local bufs = vim.tbl_filter(M.buf_loaded_n_listed, vim.api.nvim_list_bufs())

  ---@type integer[]
  local visible_bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
    table.insert(visible_bufs, vim.api.nvim_win_get_buf(win))
  end

  for _, buf in ipairs(bufs) do
    local delete = true
    for _, visible_buf in ipairs(visible_bufs) do
      if buf == visible_buf then
        delete = false
        break
      end
    end
    if delete then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end

---Displays hover information about the symbol under the cursor in a floating window. Information
---displayed comes from either LSP or DAP (depending on whether there is an active DAP session).
function M.symbol_hover()
  local has_dap, dap = pcall(require, 'dap')
  local has_dapui, dapui = pcall(require, 'dapui')
  if has_dap and has_dapui and dap.session() ~= nil then
    dapui.eval()
    return
  end
  vim.lsp.buf.hover()
end

---Returns true if buf is loaded and listed buffer.
---@param buf integer
---@return boolean
function M.buf_loaded_n_listed(buf)
  local listed = vim.api.nvim_get_option_value('buflisted', { buf = buf })
  return vim.api.nvim_buf_is_loaded(buf) and listed
end

return M
