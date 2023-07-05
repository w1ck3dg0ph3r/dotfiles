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
        -- covered = { hl = 'CoverageCovered', text = '░' },
        -- uncovered = { hl = 'CoverageUncovered', text = '░' },
        covered = { hl = 'CoverageCovered', text = '│' },
        uncovered = { hl = 'CoverageUncovered', text = '│' },
      },
      lang = {
        go = { coverage_file = '.cover' },
      },
    })

    vim.keymap.set('n', '<leader>cs', function()
      coverage.load()
      coverage.show()
    end)
    vim.keymap.set('n', '<leader>ch', function()
      coverage.clear()
    end)
  end,
}
