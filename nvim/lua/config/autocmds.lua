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

  -- Handle big files
  local big_files_group = vim.api.nvim_create_augroup('big_files', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileReadPre' }, {
    group = big_files_group,
    callback = function(ev)
      local fsize = vim.fn.getfsize(ev.match)
      if fsize > 512 * 1024 then
        vim.wo.foldmethod = 'manual'
        vim.cmd('syntax off')
        vim.b[ev.buf].big_file = true
      end
    end,
  })
end

return M
