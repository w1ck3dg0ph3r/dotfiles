local on_attach = function(bufnr)
  local gs = require('gitsigns')

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map('n', ']h', function()
    if vim.wo.diff then return ']h' end
    vim.schedule(function() gs.next_hunk() end)
    return '<ignore>'
  end, { expr = true })

  map('n', '[h', function()
    if vim.wo.diff then return '[h' end
    vim.schedule(function() gs.prev_hunk() end)
    return '<ignore>'
  end, { expr = true })

  -- Actions
  map('n', '<leader>hs', gs.stage_hunk)
  map('n', '<leader>hr', gs.reset_hunk)
  map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
  map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
  map('n', '<leader>hS', gs.stage_buffer)
  map('n', '<leader>hu', gs.undo_stage_hunk)
  map('n', '<leader>hR', gs.reset_buffer)
  map('n', '<leader>hp', gs.preview_hunk)
  map('n', '<leader>hb', function() gs.blame_line({ full = false }) end)
  map('n', '<leader>hd', function()
    gs.diffthis()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-w>h', true, false, true), 'n', false)
  end)
  map('n', '<leader>hD', function()
    gs.diffthis('~')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-w>h', true, false, true), 'n', false)
  end)
  map('n', '<leader>hts', gs.toggle_signs)
  map('n', '<leader>htd', gs.toggle_deleted)

  -- Text object
  map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>')
end

return {
  'lewis6991/gitsigns.nvim',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    on_attach = on_attach,
  },
}
