return {
  'nvim-neotest/neotest',
  version = '5',

  dependencies = {
    { 'andythigpen/nvim-coverage',     branch = 'main' },
    { 'fredrikaverpil/neotest-golang', version = '2' },
  },

  keys = {
    '<leader>tt',
    '<leader>tf',
    '<leader>tp',
    '<leader>ta',
    '<leader>ts',

    '<leader>td',
    '<leader>tdt',
    '<leader>tdl',
    '<leader>tdf',
    '<leader>tdp',

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

    local nvimrc = require('config.nvimrc').config()
    local go_coverage_enabled = util.tbl_walk(nvimrc, 'go', 'test', 'coverage_enabled') or false
    local go_coverage_file = util.tbl_walk(nvimrc, 'go', 'test', 'coverage_file') or 'coverage.out'
    local go_args = { '-race' }
    if go_coverage_enabled then
      table.insert(go_args, '-coverprofile')
      table.insert(go_args, go_coverage_file)
    end

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup({
      adapters = {
        require('neotest-golang')(
        ---@type NeotestGolangOptions
          {
            go_test_args = go_args,
            dap_go_enabled = true,
            warn_test_name_dupes = false,
          }
        ),
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

    util.map('n', '<leader>tt', function() neotest.run.run() end, { desc = 'Test: Run' })
    util.map('n', '<leader>tl', function() neotest.run.run_last() end, { desc = 'Test: Run last' })
    util.map('n', '<leader>tf', function() neotest.run.run(vim.fn.expand('%')) end, { desc = 'Test: Run file' })
    util.map('n', '<leader>tp', function() neotest.run.run(vim.fn.expand('%:h')) end, { desc = 'Test: Run package' })
    util.map('n', '<leader>ta', function() neotest.run.run(vim.fn.getcwd()) end, { desc = 'Test: Run all' })

    util.map('n', '<leader>td', function()
      neotest.run.run({ strategy = 'dap', suite = false })
    end, { desc = 'Test: Debug' })
    util.map('n', '<leader>tdl', function()
      neotest.run.run_last({ strategy = 'dap', suite = true })
    end, { desc = 'Test: Debug last' })
    util.map('n', '<leader>tdf', function()
      neotest.run.run({ vim.fn.expand('%'), strategy = 'dap', suite = true })
    end, { desc = 'Test: Debug file' })
    util.map('n', '<leader>tdp', function()
      neotest.run.run({ vim.fn.expand('%:h'), strategy = 'dap', suite = true })
    end, { desc = 'Test: Debug package' })

    util.map('n', '<leader>tq', function() neotest.run.stop() end, { desc = 'Test: Stop' })

    util.map('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = 'Test: Toggle summary' })
    util.map('n', '<leader>to', function() neotest.output.open() end, { desc = 'Test: Show output' })
    util.map('n', '<leader>tw', function() neotest.output_panel.toggle() end, { desc = 'Test: Show output panel' })

    util.map('n', '<leader>tcs', function() coverage.load(true) end, { desc = 'Test: Load coverage' })
    util.map('n', '<leader>tch', function() coverage.clear() end, { desc = 'Test: Clear coverage' })
  end,
}
