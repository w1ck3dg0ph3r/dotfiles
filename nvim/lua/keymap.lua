require('utils')

-- leave '\' as leader
-- map('n', '<space>', '<nop>')
-- vim.g.mapleader = ' '

-- Escape insert mode quickly
map('i', 'kj', '<esc>')
map('i', 'jk', '<esc>')

-- Clear search highlighting with <leader> and c
map('n', '<leader>c', '<cmd>nohl<cr>')

-- Fast saving with <leader> and s
map('n', '<leader>s', '<cmd>w<cr>')
map('i', '<leader>s', '<c-c>:w<cr>')

-- Indent stay in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Fast quitting with <leader> and q
map('n', '<leader>q', ':qa<cr>')
map('i', '<leader>q', '<c-c>:qa<cr>')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<c-h>', '<c-w>h')
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')
-- Move around splits using Ctrl + {left,down,up,right}
map('n', '<c-left>', '<c-w>h')
map('n', '<c-down>', '<c-w>j')
map('n', '<c-up>', '<c-w>k')
map('n', '<c-right>', '<c-w>l')

-- Buffers
map('n', '<a-h>', '<cmd>bp<cr>')
map('n', '<a-j>', '<cmd>b#<cr>')
map('n', '<a-l>', '<cmd>bn<cr>')
map('n', '<leader>w', '<cmd>bw|bn<cr>')
map('i', '<leader>w', '<c-c><cmd>bw|bn<cr>')
