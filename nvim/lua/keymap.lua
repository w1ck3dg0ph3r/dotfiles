local util = require('util')

-- leave '\' as leader
-- util.map('n', '<space>', '<nop>')
-- vim.g.mapleader = ' '

-- Escape insert mode quickly
util.map('i', 'kj', '<esc>')
util.map('i', 'jk', '<esc>')

-- Clear search highlighting with <leader> and c
util.map('n', '<leader>c', '<cmd>nohl<cr>')

-- Fast saving with <leader> and s
util.map('n', '<leader>s', '<cmd>w<cr>')
util.map('i', '<leader>s', '<c-c>:w<cr>')

-- Indent stay in visual mode
util.map('v', '<', '<gv')
util.map('v', '>', '>gv')

-- Fast quitting with <leader> and q
util.map('n', '<leader>q', ':qa<cr>')
util.map('i', '<leader>q', '<c-c>:qa<cr>')

-- Move around splits using Ctrl + {h,j,k,l}
util.map('n', '<c-h>', '<c-w>h')
util.map('n', '<c-j>', '<c-w>j')
util.map('n', '<c-k>', '<c-w>k')
util.map('n', '<c-l>', '<c-w>l')
-- Move around splits using Ctrl + {left,down,up,right}
util.map('n', '<c-left>', '<c-w>h')
util.map('n', '<c-down>', '<c-w>j')
util.map('n', '<c-up>', '<c-w>k')
util.map('n', '<c-right>', '<c-w>l')

-- Buffers
util.map('n', '<a-h>', '<cmd>bp<cr>')
util.map('n', '<a-g>', '<cmd>b#<cr>')
util.map('n', '<a-l>', '<cmd>bn<cr>')
util.map('n', '<leader>g', '<cmd>BufferLinePick<cr>')
util.map('n', '<leader>w', '<cmd>bw|bn<cr>')
util.map('i', '<leader>w', '<c-c><cmd>bw|bn<cr>')

-- Move lines around
util.map('n', '<a-j>', '<cmd>m .+1<cr>==')
util.map('n', '<a-k>', '<cmd>m .-2<cr>==')
util.map('i', '<a-j>', '<esc><cmd>m .+1<cr>==gi')
util.map('i', '<a-k>', '<esc><cmd>m .-2<cr>==gi')
util.map('v', '<a-j>', ':m \'>+1<cr>gv=gv')
util.map('v', '<a-k>', ':m \'<-2<cr>gv=gv')

-- Diagnostics
util.map('n', '[d', vim.diagnostic.goto_prev)
util.map('n', ']d', vim.diagnostic.goto_next)
util.map('n', '<leader>df', vim.diagnostic.open_float)
util.map('n', '<leader>dl', vim.diagnostic.setloclist)
