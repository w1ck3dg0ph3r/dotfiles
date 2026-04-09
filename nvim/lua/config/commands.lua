local M = {}

function M.setup()
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

  vim.api.nvim_create_user_command('LspInfo', function()
    vim.cmd('checkhealth vim.lsp')
  end, {})

  -- Restart nvim preserving buffers using temporary session
  vim.api.nvim_create_user_command('Restart', function()
    local session = vim.fn.stdpath('state') .. '/restart_session.vim'
    vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
    vim.cmd('restart source ' .. vim.fn.fnameescape(session))
  end, { desc = 'Restart neovim' })
end

return M
