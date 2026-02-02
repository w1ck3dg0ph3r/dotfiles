local M = {
  'lewis6991/gitsigns.nvim',
  version = '2',

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
  },
}

M.opts.on_attach = function(bufnr)
  local util = require('util')
  local gs = require('gitsigns')

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    util.map(mode, l, r, opts)
  end

  -- Navigation
  local gs_next_hunk, gs_prev_hunk = util.make_repeatable_move(
    function() gs.nav_hunk('next') end,
    function() gs.nav_hunk('prev') end
  )
  map('n', ']h', gs_next_hunk, {})
  map('n', '[h', gs_prev_hunk, {})

  -- Actions
  map('n', '<leader>hs', gs.stage_hunk)
  map('n', '<leader>hr', gs.reset_hunk)
  map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
  map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
  map('n', '<leader>hS', gs.stage_buffer)
  map('n', '<leader>hR', gs.reset_buffer)
  map('n', '<leader>hp', gs.preview_hunk)
  map('n', '<leader>hi', gs.preview_hunk_inline)
  map('n', '<leader>hb', function() gs.blame_line({ full = true }) end)
  map('n', '<leader>hd', function()
    gs.diffthis()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-w>h', true, false, true), 'n', false)
  end)
  map('n', '<leader>hD', function()
    gs.diffthis('~')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-w>h', true, false, true), 'n', false)
  end)
  map('n', '<leader>hts', gs.toggle_signs)

  -- Text object
  map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>')
end

return M
