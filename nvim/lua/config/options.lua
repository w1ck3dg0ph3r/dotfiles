vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.o.lazyredraw = true

vim.o.timeout = true
vim.o.timeoutlen = 500

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Configure leader
vim.keymap.set('n', '<space>', '<nop>')
vim.g.mapleader = ' '

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.o.completeopt = 'menu,menuone,noselect'

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

vim.o.wrap = false
vim.o.formatoptions = 'cronjq'

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.breakindent = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Visible whitespace
vim.o.list = true
vim.opt.listchars:append 'space:⋅'
vim.opt.listchars:append 'tab:» '

-- Code folding
vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
vim.o.foldnestmax = 10
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldcolumn = '1'

vim.g.omni_sql_no_default_maps = true -- Disable default sql completion with c-c

-- Diagnostic icons
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
