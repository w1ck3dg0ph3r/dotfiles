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

M.opts.on_attach = function(buf)
  local util = require('util')
  local gs = require('gitsigns')

  -- Navigation
  local gs_next_hunk, gs_prev_hunk = util.make_repeatable_move(
    function() gs.nav_hunk('next') end,
    function() gs.nav_hunk('prev') end
  )
  util.map('n', ']h', gs_next_hunk, { buf = buf, desc = 'Git: Next hunk' })
  util.map('n', '[h', gs_prev_hunk, { buf = buf, desc = 'Git: Previous hunk' })

  -- Actions
  util.map('n', '<leader>hs', gs.stage_hunk, { buf = buf, desc = 'Git: Stage hunk' })
  util.map('n', '<leader>hr', gs.reset_hunk, { buf = buf, desc = 'Git: Reset hunk' })
  util.map('v', '<leader>hs', function()
    gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, { buf = buf, desc = 'Git: Stage selection' })
  util.map('v', '<leader>hr', function()
    gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, { buf = buf, desc = 'Git: Reset selection' })
  util.map('n', '<leader>hS', gs.stage_buffer, { buf = buf, desc = 'Git: Stage buffer' })
  util.map('n', '<leader>hR', gs.reset_buffer, { buf = buf, desc = 'Git: Reset buffer' })
  util.map('n', '<leader>hp', gs.preview_hunk, { buf = buf, desc = 'Git: Preview hunk' })
  util.map('n', '<leader>hi', gs.preview_hunk_inline, { buf = buf, desc = 'Git: Preview hunk inline' })
  util.map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { buf = buf, desc = 'Git: Blame line' })
  util.map('n', '<leader>hd', function()
    gs.diffthis()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-w>h', true, false, true), 'n', false)
  end, { buf = buf, desc = 'Git: Show index diff' })
  util.map('n', '<leader>hD', function()
    gs.diffthis('~')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-w>h', true, false, true), 'n', false)
  end, { buf = buf, desc = 'Git: Show diff' })
  util.map('n', '<leader>hts', gs.toggle_signs, { buf = buf, desc = 'Git: Toggle signs' })

  -- Text object
  util.map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', { buf = buf, desc = 'Git: Select hunk' })
end

return M
