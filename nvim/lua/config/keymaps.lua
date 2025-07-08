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

-- Keep cursor centered
util.map('n', '<c-d>', '<c-d>zz')
util.map('n', '<c-u>', '<c-u>zz')

-- Move around splits using Ctrl + {h,j,k,l}
util.map('n', '<c-h>', '<c-w>h')
util.map('n', '<c-j>', '<c-w>j')
util.map('n', '<c-k>', '<c-w>k')
util.map('n', '<c-l>', '<c-w>l')

-- Buffers
util.map('n', '<a-h>', '<cmd>bp<cr>')
util.map('n', '<a-g>', '<cmd>b#<cr>')
util.map('n', '<a-l>', '<cmd>bn<cr>')
-- util.map('n', '<leader>w', '<cmd>:bn<cr>:bd#<cr>')

util.map('n', '<leader>w', function()
  local loaded_n_listed = function(buf)
    local listed = vim.api.nvim_get_option_value('buflisted', { buf = buf })
    return vim.api.nvim_buf_is_loaded(buf) and listed
  end
  local bufs = vim.tbl_filter(loaded_n_listed, vim.api.nvim_list_bufs())
  local wins = vim.api.nvim_list_wins()

  if #wins == 1 then
    if #bufs == 1 then
      vim.cmd('q')
    else
      vim.cmd('bd')
    end
  else
    if #bufs == 1 then
      vim.cmd('q')
      vim.cmd('q')
    else
      vim.cmd('bn')
      vim.cmd('bd#')
    end
  end
end)

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

-- LSP hover and DAP eval
util.map('n', 'K', function()
  local has_dap, dap = pcall(require, 'dap')
  local has_dapui, dapui = pcall(require, 'dapui')
  if has_dap and has_dapui and dap.session() ~= nil then
    dapui.eval()
    return
  end
  vim.lsp.buf.hover()
end, { silent = true })
