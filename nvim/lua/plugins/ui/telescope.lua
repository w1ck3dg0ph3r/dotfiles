return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
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
    if has_trouble then trouble_telescope = require('trouble.providers.telescope') end
    if has_trouble then
      local open_trouble_quickfix = action_mt.transform('open_trouble_quickfix', action_mt.create(), _, function(_)
        vim.schedule(function()
          trouble.open({ mode = 'quickfix', focus = true })
          trouble.first({ mode = 'quickfix' })
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
      opts.defaults.mappings.i['<c-t>'] = trouble_telescope.smart_open_with_trouble
      opts.defaults.mappings.n['<c-t>'] = trouble_telescope.smart_open_with_trouble
    end

    telescope.setup(opts)
    local builtin = require('telescope.builtin')

    util.map('n', '<leader>sc', function() builtin.commands() end)
    util.map('n', '<leader>sb', function() builtin.buffers(themes.get_dropdown()) end)
    util.map('n', '<leader>sh', builtin.help_tags)
    util.map('n', '<leader>sf', function() builtin.find_files({ hidden = true }) end)
    util.map('n', '<leader>sg', builtin.live_grep)
    util.map('n', '<leader>ss', builtin.current_buffer_fuzzy_find)
    util.map('n', '<leader>so', builtin.lsp_document_symbols)
    util.map('n', '<leader>st', builtin.lsp_dynamic_workspace_symbols)
    util.map('n', '<leader>sw', function() builtin.lsp_workspace_symbols({ query = vim.fn.input('Query: ') }) end)
    util.map('n', '<leader>sr', builtin.lsp_references)
    util.map('n', '<leader>si', builtin.lsp_implementations)
    util.map('n', '<leader>sd', builtin.diagnostics)

    -- Workaroud for telescope opening files in insert mode
    vim.api.nvim_create_autocmd('WinLeave', {
      callback = function()
        if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'i', false)
        end
      end,
    })
  end,
}
