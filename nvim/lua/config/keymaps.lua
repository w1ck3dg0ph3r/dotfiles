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
  local picker = require('snacks.picker')
  util.map('n', 'z=', picker.spelling)

  -- Changes
  local next_change, prev_change = util.make_repeatable_move(']c', '[c')
  util.map('n', ']c', next_change)
  util.map('n', '[c', prev_change)

  -- LSP hover and DAP eval
  util.map({ 'n', 'v' }, 'K', M.symbol_hover, { silent = true })
end

---Delete current buffer, preserving window if there are other buffers present.
function M.delete_buffer()
  local current_buf = vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(current_buf) then
    return
  end

  if not M.is_normal_buffer(current_buf) then
    vim.cmd('bdelete!')
    return
  end

  local last_buf = M.last_used_buffer(current_buf)
  if not last_buf then
    vim.cmd('qall')
    return
  end

  for _, win in ipairs(vim.fn.win_findbuf(current_buf)) do
    local new_buf = last_buf
    vim.api.nvim_win_call(win, function()
      local alt_buf = vim.fn.bufnr("#")
      if alt_buf >= 0 and alt_buf ~= current_buf and vim.bo[alt_buf].buflisted then
        new_buf = alt_buf
      end
    end)
    vim.api.nvim_win_set_buf(win, new_buf)
  end
  vim.api.nvim_buf_delete(current_buf, {})
end

---Deletes all buffers not visible in windows on a current tab.
function M.delete_other_buffers()
  local bufs = vim.tbl_filter(M.is_normal_buffer, vim.api.nvim_list_bufs())

  ---@type table<integer,boolean>
  local visible_bufs = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
    visible_bufs[vim.api.nvim_win_get_buf(win)] = true
  end

  for _, buf in ipairs(bufs) do
    if not visible_bufs[buf] then
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

---Returns true if buf is a normal buffer.
---@param buf integer
---@return boolean
function M.is_normal_buffer(buf)
  local listed = vim.api.nvim_get_option_value('buflisted', { buf = buf })
  local type = vim.api.nvim_get_option_value('buftype', { buf = buf })
  local hidden = vim.api.nvim_get_option_value('bufhidden', { buf = buf })
  return vim.api.nvim_buf_is_loaded(buf) and listed and type == '' and hidden == ''
end

---Returns last used buffer that is not current_buf.
---@param current_buf number
---@return number|nil
function M.last_used_buffer(current_buf)
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  ---@param b vim.fn.getbufinfo.ret.item
  bufs = vim.tbl_filter(function(b)
    return b.bufnr ~= current_buf and M.is_normal_buffer(b.bufnr)
  end, bufs)
  table.sort(bufs, function(a, b)
    return a.lastused > b.lastused
  end)
  return bufs[1] and bufs[1].bufnr or nil
end

return M
