return {
  'nvim-neotest/neotest',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'andythigpen/nvim-coverage',
    { 'nvim-neotest/neotest-go', commit = '05535cb' },
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
    local util = require('util')

    local nvimrc = require('nvimrc').config()
    local go_coverage_enabled = util.tbl_walk(nvimrc, 'go', 'test', 'coverage_enabled') or true
    local go_coverage_file = util.tbl_walk(nvimrc, 'go', 'test', 'coverage_file') or 'coverage.out'
    local neotest_go_args = { '-race' }
    if go_coverage_enabled then
      table.insert(neotest_go_args, '-coverprofile ' .. go_coverage_file)
    end

    neotest.setup({
      adapters = {
        require('neotest-go')({
          experimental = {
            test_table = true,
          },
          args = neotest_go_args,
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
        go = { coverage_file = go_coverage_file },
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
