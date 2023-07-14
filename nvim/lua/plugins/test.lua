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

    local neotest = require('neotest')

    neotest.setup({
      adapters = {
        require('neotest-go')({
          experimental = {
            test_table = true,
          },
          args = { '-race', '-coverprofile coverage.out' },
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
        go = { coverage_file = 'coverage.out' },
      },
    })

    vim.keymap.set('n', '<leader>tt', function() neotest.run.run() end)
    vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end)
    vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand('%')) end)
    vim.keymap.set('n', '<leader>tp', function() neotest.run.run(vim.fn.expand('%:h')) end)
    vim.keymap.set('n', '<leader>ta', function() neotest.run.run(vim.fn.getcwd()) end)

    -- Not suported yet by neotest-go, but can be run through dap directly
    vim.keymap.set('n', '<leader>tdt', function() neotest.run.run({ strategy = 'dap' }) end)
    vim.keymap.set('n', '<leader>tdl', function() neotest.run.run_last({ strategy = 'dap' }) end)
    vim.keymap.set('n', '<leader>tdf', function() neotest.run.run({ vim.fn.expand('%'), strategy = 'dap' }) end)
    vim.keymap.set('n', '<leader>tdp', function() neotest.run.run({ vim.fn.expand('%:h'), strategy = 'dap' }) end)

    vim.keymap.set('n', '<leader>tq', function() neotest.run.stop() end)

    vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end)
    vim.keymap.set('n', '<leader>to', function() neotest.output.open() end)
    vim.keymap.set('n', '<leader>tw', function() neotest.output_panel.toggle() end)

    vim.keymap.set('n', '<leader>cs', function() coverage.load(true) end)
    vim.keymap.set('n', '<leader>ch', function() coverage.clear() end)
  end,
}
