return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',

  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects',  branch = 'main' },
    { 'MeanderingProgrammer/treesitter-modules.nvim', branch = 'main' },
  },

  event = 'UIEnter',

  config = function()
    require('nvim-treesitter.install').update({ with_sync = true })
    local repeatable_move = require('nvim-treesitter-textobjects.repeatable_move')
    local util = require('util')

    --- @param ctx ts.mod.Context
    local is_big_file = function(ctx)
      return vim.b[ctx.buf].big_file
    end

    require('nvim-treesitter').setup()

    require('nvim-treesitter-textobjects').setup({
      select = {
        lookahead = true,
        selection_modes = {
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
          ['@block.outer'] = 'V',
        },
      },
      move = {
        set_jumps = false,
      },
    })

    require('treesitter-modules').setup({
      incremental_selection = {
        enable = true,
        disable = is_big_file,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-e>',
        },
      },
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter.setup', { clear = true }),
      callback = function(args)
        local buf = args.buf
        if is_big_file({ buf = buf, language = '' }) then
          return
        end

        local filetype = args.match
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
          return
        end

        -- Enable fold
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        -- Enable highlight
        vim.treesitter.start(buf, language)

        -- Enable indent
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    })

    local select = require('nvim-treesitter-textobjects.select')
    util.map({ 'x', 'o' }, 'if', function() select.select_textobject('@fuction.inner') end)
    util.map({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer') end)
    util.map({ 'x', 'o' }, 'it', function() select.select_textobject('@class.inner') end)
    util.map({ 'x', 'o' }, 'at', function() select.select_textobject('@class.outer') end)
    util.map({ 'x', 'o' }, 'ip', function() select.select_textobject('@parameter.inner') end)
    util.map({ 'x', 'o' }, 'ap', function() select.select_textobject('@parameter.outer') end)

    local move = require('nvim-treesitter-textobjects.move')
    util.map({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start('@function.outer') end)
    util.map({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start('@function.outer') end)
    util.map({ 'n', 'x', 'o' }, ']t', function() move.goto_next_start('@class.outer') end)
    util.map({ 'n', 'x', 'o' }, '[t', function() move.goto_previous_start('@class.outer') end)
    util.map({ 'n', 'x', 'o' }, ']p', function() move.goto_next_start('@parameter.inner') end)
    util.map({ 'n', 'x', 'o' }, '[p', function() move.goto_previous_start('@parameter.inner') end)

    local swap = require('nvim-treesitter-textobjects.swap')
    util.map({ 'n' }, '<a-]>f', function() swap.swap_next('@function.outer') end)
    util.map({ 'n' }, '<a-[>f', function() swap.swap_previous('@function.outer') end)
    util.map({ 'n' }, '<a-]>t', function() swap.swap_next('@class.outer') end)
    util.map({ 'n' }, '<a-[>t', function() swap.swap_previous('@class.outer') end)
    util.map({ 'n' }, '<a-]>p', function() swap.swap_next('@parameter.inner') end)
    util.map({ 'n' }, '<a-[>p', function() swap.swap_previous('@parameter.inner') end)

    -- Repeat movements
    util.map({ 'n', 'x', 'o' }, ';', function() pcall(repeatable_move.repeat_last_move) end)
    util.map({ 'n', 'x', 'o' }, ',', function() pcall(repeatable_move.repeat_last_move_opposite) end)
    util.map({ 'n', 'x', 'o' }, 'f', repeatable_move.builtin_f_expr, { expr = true })
    util.map({ 'n', 'x', 'o' }, 'F', repeatable_move.builtin_F_expr, { expr = true })
    util.map({ 'n', 'x', 'o' }, 't', repeatable_move.builtin_t_expr, { expr = true })
    util.map({ 'n', 'x', 'o' }, 'T', repeatable_move.builtin_T_expr, { expr = true })
  end,
}
