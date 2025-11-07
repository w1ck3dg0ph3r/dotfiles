return {
  'nvim-telescope/telescope.nvim',
  branch = 'master',

  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', branch = 'main' },
  },

  keys = {
    '<leader>sc',
    '<leader>sb',
    '<leader>sh',
    '<leader>sf',
    '<leader>sg',
    '<leader>ss',
    '<leader>so',
    '<leader>st',
    '<leader>sr',
    '<leader>sd',
  },

  opts = {
    defaults = {
      mappings = {
        i = {
          ['<esc>'] = 'close',
        },
        n = {},
      },

      file_ignore_patterns = { '^%.git/' },
    },
  },

  config = function(_, opts)
    local telescope = require('telescope')
    local themes = require('telescope.themes')
    local util = require('util')

    local actions = require('telescope.actions')
    local action_mt = require('telescope.actions.mt')

    -- Set up trouble
    local has_trouble, trouble = pcall(require, 'trouble')
    local trouble_telescope
    if has_trouble then
      trouble_telescope = require('trouble.sources.telescope')
      local open_trouble_quickfix = action_mt.transform('open_trouble_quickfix', action_mt.create(), _, function(_)
        vim.schedule(function()
          local tv = trouble.open({ mode = 'quickfix', focus = true })
          if tv then trouble.first(tv, {}) end
        end)
      end)

      local open_quckfix_in_trouble = false
      if open_quckfix_in_trouble then
        opts.defaults.mappings.i['<c-q>'] = actions.smart_send_to_qflist + open_trouble_quickfix
        opts.defaults.mappings.n['<c-q>'] = actions.smart_send_to_qflist + open_trouble_quickfix
      else
        opts.defaults.mappings.i['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist
        opts.defaults.mappings.n['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist
      end
      opts.defaults.mappings.i['<c-t>'] = trouble_telescope.open
      opts.defaults.mappings.n['<c-t>'] = trouble_telescope.open
    end

    telescope.setup(opts)
    local builtin = require('telescope.builtin')

    util.map('n', '<leader>sc', function() builtin.commands() end)
    util.map('n', '<leader>sb', function()
      builtin.buffers(vim.tbl_extend('force', themes.get_dropdown({
        layout_config = {
          width = function(_, max_columns, _)
            return math.min(max_columns, 100)
          end,
        },
      }), {
        show_all_buffers = false,
        ignore_current_buffer = true,
      }))
    end)
    util.map('n', '<leader>sh', builtin.help_tags)
    util.map('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end)
    util.map('n', '<leader>sg', builtin.live_grep)
    util.map('n', '<leader>ss', builtin.current_buffer_fuzzy_find)
    util.map('n', '<leader>so', function()
      builtin.lsp_document_symbols({
        ignore_symbols = { 'field', 'enummember' },
        symbol_width = 60,
        symbol_type_width = 8,
      })
    end)
    util.map('n', '<leader>st', builtin.lsp_dynamic_workspace_symbols)
    util.map('n', '<leader>sw', function() builtin.lsp_workspace_symbols({ query = vim.fn.input('Query: ') }) end)
    util.map('n', '<leader>sr', builtin.lsp_references)
    util.map('n', '<leader>sci', builtin.lsp_incoming_calls)
    util.map('n', '<leader>sco', builtin.lsp_outgoing_calls)
    util.map('n', '<leader>si', builtin.lsp_implementations)
    util.map('n', '<leader>sd', builtin.diagnostics)
    util.map('n', '<leader>sD', function() builtin.diagnostics({ bufnr = 0 }) end)
  end,
}
