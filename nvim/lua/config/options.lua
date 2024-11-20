vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.termguicolors = true
vim.opt.lazyredraw = true

vim.keymap.set('n', '<space>', '<nop>')
vim.g.mapleader = ' '
vim.opt.timeout = true
vim.opt.timeoutlen = 500

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.mouse = 'a'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.completeopt = { 'menuone', 'noselect' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.wrap = false
vim.opt.formatoptions = 'cronjq'

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Visible whitespace
vim.opt.list = true
vim.opt.listchars:append('space:⋅')
vim.opt.listchars:append('tab:» ')

-- Code folding
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldnestmax = 10
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldcolumn = '1'

vim.g.omni_sql_no_default_maps = true -- Disable default sql completion with c-c

-- Diagnostic icons
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
