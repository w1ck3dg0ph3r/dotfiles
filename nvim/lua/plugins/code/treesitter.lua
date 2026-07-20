---@module 'lazy.types'

---@class LazyPluginSpec
local M = {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',

  lazy = false,

  dependencies = {
    { 'w1ck3dg0ph3r/nvim-treesitter-textobjects',     branch = 'main' },
    { 'MeanderingProgrammer/treesitter-modules.nvim', branch = 'main' },
  },

  event = 'UIEnter',
}

function M.config()
  require('nvim-treesitter.install').update({ with_sync = true })
  local util = require('util')

  require('nvim-treesitter').setup()

  require('nvim-treesitter-textobjects').setup({
    select = {
      lookahead = true,
      selection_modes = {
        ['@function.outer'] = 'v',
        ['@class.outer'] = 'v',
        ['@block.outer'] = 'v',
      },
    },
    move = {
      set_jumps = false,
    },
  })

  require('treesitter-modules').setup({
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<c-e>',
      },
    },
  })

  util.map('n', ']f', function() end)
  util.map('n', '[f', function() end)

  vim.api.nvim_create_user_command('TSInspectTree', function()
    vim.treesitter.inspect_tree({
      command = '120vnew',
    })
  end, {})
end

function M.setup_aucmds()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter.setup', { clear = true }),
    callback = function(args)
      local buf = args.buf

      local filetype = args.match
      local language = vim.treesitter.language.get_lang(filetype) or filetype
      if not vim.treesitter.language.add(language) then
        return
      end

      local repeatable_move = require('nvim-treesitter-textobjects.repeatable_move')
      local util = require('util')

      local select = require('nvim-treesitter-textobjects.select')
      util.map({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner') end, { desc = 'Select: Inside function', buf = buf })
      util.map({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer') end, { desc = 'Select: Outside function', buf = buf })
      util.map({ 'x', 'o' }, 'it', function() select.select_textobject('@class.inner') end, { desc = 'Select: Inside type', buf = buf })
      util.map({ 'x', 'o' }, 'at', function() select.select_textobject('@class.outer') end, { desc = 'Select: Outside type', buf = buf })
      util.map({ 'x', 'o' }, 'ip', function() select.select_textobject('@parameter.inner') end, { desc = 'Select: Inside parameter', buf = buf })
      util.map({ 'x', 'o' }, 'ap', function() select.select_textobject('@parameter.outer') end, { desc = 'Select: Outside parameter', buf = buf })

      local move = require('nvim-treesitter-textobjects.move')
      util.map({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start('@function.outer') end, { desc = 'Move: Next function', buf = buf })
      util.map({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start('@function.outer') end, { desc = 'Move: Previous function', buf = buf })
      util.map({ 'n', 'x', 'o' }, ']t', function() move.goto_next_start('@class.outer') end, { desc = 'Move: Next type', buf = buf })
      util.map({ 'n', 'x', 'o' }, '[t', function() move.goto_previous_start('@class.outer') end, { desc = 'Move: Previous type', buf = buf })
      util.map({ 'n', 'x', 'o' }, ']p', function() move.goto_next_start('@parameter.inner') end, { desc = 'Move: Next parameter', buf = buf })
      util.map({ 'n', 'x', 'o' }, '[p', function() move.goto_previous_start('@parameter.inner') end, { desc = 'Move: Previous parameter', buf = buf })

      local swap = require('nvim-treesitter-textobjects.swap')
      util.map({ 'n' }, '<a-]>f', function() swap.swap_next('@function.outer') end, { desc = 'Swap: Next function', buf = buf })
      util.map({ 'n' }, '<a-[>f', function() swap.swap_previous('@function.outer') end, { desc = 'Swap: Previous function', buf = buf })
      util.map({ 'n' }, '<a-]>t', function() swap.swap_next('@class.outer') end, { desc = 'Swap: Next type', buf = buf })
      util.map({ 'n' }, '<a-[>t', function() swap.swap_previous('@class.outer') end, { desc = 'Swap: Previous type', buf = buf })
      util.map({ 'n' }, '<a-]>p', function() swap.swap_next('@parameter.inner') end, { desc = 'Swap: Next parameter', buf = buf })
      util.map({ 'n' }, '<a-[>p', function() swap.swap_previous('@parameter.inner') end, { desc = 'Swap: Previous parameter', buf = buf })

      -- Repeat movements
      util.map({ 'n', 'x', 'o' }, ';', function() pcall(repeatable_move.repeat_last_move) end, { desc = 'Repeat last move' })
      util.map({ 'n', 'x', 'o' }, ',', function() pcall(repeatable_move.repeat_last_move_opposite) end, { desc = 'Repeat last move backwards' })
      util.map({ 'n', 'x', 'o' }, 'f', repeatable_move.builtin_f_expr, { expr = true })
      util.map({ 'n', 'x', 'o' }, 'F', repeatable_move.builtin_F_expr, { expr = true })
      util.map({ 'n', 'x', 'o' }, 't', repeatable_move.builtin_t_expr, { expr = true })
      util.map({ 'n', 'x', 'o' }, 'T', repeatable_move.builtin_T_expr, { expr = true })

      -- Enable fold
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

      -- Enable highlight
      vim.treesitter.start(buf, language)
    end
  })
end

M.setup_aucmds()

return M
