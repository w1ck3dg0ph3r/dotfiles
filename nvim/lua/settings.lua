vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.o.completeopt = 'menu,menuone,noselect'

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

vim.o.wrap = false

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
vim.o.foldnestmax = 1
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.fillchars = 'eob:~,fold:·,foldopen:,foldsep: ,foldclose:'
vim.o.foldcolumn = '2'

-- Fix no folding with telescope
vim.api.nvim_create_autocmd('BufRead', {
  callback = function()
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      command = 'normal! zx'
    })
  end
})

-- Diagnostic icons
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Toggle relative numbers and cursorline for focused buffer
local line_numbers_group = vim.api.nvim_create_augroup('line_numbers', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'WinEnter' }, {
  group = line_numbers_group,
  callback = function()
    if vim.o.number then
      vim.o.relativenumber = true
      vim.o.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'WinLeave' }, {
  group = line_numbers_group,
  callback = function()
    if vim.o.number then
      vim.o.relativenumber = false
      vim.o.cursorline = false
      vim.cmd('redraw')
    end
  end,
})
