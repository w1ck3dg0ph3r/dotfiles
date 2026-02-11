-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- General Behaviour
vim.opt.mouse = 'a'
vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.formatoptions = 'cronjq'

-- Leader
vim.keymap.set('n', '<space>', '<nop>')
vim.g.mapleader = ' '
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- Lines and scrolling
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.sidescroll = 1

-- Indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Visible whitespace
vim.opt.list = true
vim.opt.listchars:append('space:⋅')
vim.opt.listchars:append('tab:» ')

-- Folding
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
vim.opt.foldcolumn = '1'

-- Spelling
vim.opt.spellfile = {
  vim.fn.stdpath('data') .. '/spell/en.utf-8.add',
  '.nvimspell.utf-8.add',
}

-- Diagnostic icons
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
})
-- Telescope still uses those:
local signs = { Error = '', Warn = '', Info = '', Hint = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Some hacks
vim.g.omni_sql_no_default_maps = true -- Disable default sql completion with c-c
