return {
  'nvim-neotest/neotest',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'andythigpen/nvim-coverage',
    'nvim-neotest/neotest-go',
  },

  config = function()
    local neotest_ns = vim.api.nvim_create_namespace('neotest')
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
              diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)

    require('neotest').setup({
      adapters = {
        require('neotest-go')({
          experimental = {
            test_table = true,
          },
        }),
      },
    })

    local coverage = require('coverage')
    coverage.setup({
      signs = {
        covered = { hl = 'CoverageCovered', text = '░' },
        uncovered = { hl = 'CoverageUncovered', text = '░' },
      },
      lang = {
        go = { coverage_file = '.cover' },
      },
    })

    vim.keymap.set('n', '<leader>tt', '<cmd>Neotest run<cr>')
    vim.keymap.set('n', '<leader>tf', '<cmd>Neotest run file<cr>')
    vim.keymap.set('n', '<leader>ts', '<cmd>Neotest summary<cr>')
    vim.keymap.set('n', '<leader>to', '<cmd>Neotest output<cr>')
    vim.keymap.set('n', '<leader>tp', '<cmd>Neotest output-panel<cr>')

    vim.keymap.set('n', '<leader>cs', function() coverage.load(true) end)
    vim.keymap.set('n', '<leader>ch', function() coverage.clear() end)
  end,
}
