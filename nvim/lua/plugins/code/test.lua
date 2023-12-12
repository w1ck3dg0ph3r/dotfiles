return {
  'nvim-neotest/neotest',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'andythigpen/nvim-coverage',
    { 'nvim-neotest/neotest-go', commit = '05535cb' },
  },

  keys = {
    '<leader>tt',
    '<leader>tf',
    '<leader>tp',
    '<leader>ta',
    '<leader>ts',

    '<leader>tcs',
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

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup({
      adapters = {
        require('neotest-go')({
          experimental = {
            test_table = false,
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

    util.map('n', '<leader>tt', function() neotest.run.run() end)
    util.map('n', '<leader>tl', function() neotest.run.run_last() end)
    util.map('n', '<leader>tf', function() neotest.run.run(vim.fn.expand('%')) end)
    util.map('n', '<leader>tp', function() neotest.run.run(vim.fn.expand('%:h')) end)
    util.map('n', '<leader>ta', function() neotest.run.run(vim.fn.getcwd()) end)

    -- Not suported yet by neotest-go, but can be run through dap directly
    util.map('n', '<leader>tdt', function() neotest.run.run({ strategy = 'dap', suite = true }) end)
    util.map('n', '<leader>tdl', function() neotest.run.run_last({ strategy = 'dap', suite = true }) end)
    util.map('n', '<leader>tdf',
      function() neotest.run.run({ vim.fn.expand('%'), strategy = 'dap', suite = true }) end)
    util.map('n', '<leader>tdp',
      function() neotest.run.run({ vim.fn.expand('%:h'), strategy = 'dap', suite = true }) end)

    util.map('n', '<leader>tq', function() neotest.run.stop() end)

    util.map('n', '<leader>ts', function() neotest.summary.toggle() end)
    util.map('n', '<leader>to', function() neotest.output.open() end)
    util.map('n', '<leader>tw', function() neotest.output_panel.toggle() end)

    util.map('n', '<leader>tcs', function() coverage.load(true) end)
    util.map('n', '<leader>tch', function() coverage.clear() end)
  end,
}
