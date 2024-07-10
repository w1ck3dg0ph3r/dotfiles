local on_attach = function(bufnr)
  local util = require('util')
  local gs = require('gitsigns')

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    util.map(mode, l, r, opts)
  end

  -- Navigation
  local has_repeat_move, ts_repeat_move = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
  local gs_next_hunk, gs_prev_hunk = gs.next_hunk, gs.prev_hunk
  if has_repeat_move then
    gs_next_hunk, gs_prev_hunk = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  end
  map('n', ']h', gs_next_hunk, {})
  map('n', '[h', gs_prev_hunk, {})

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
