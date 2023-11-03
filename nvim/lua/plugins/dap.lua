return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
    'jay-babu/mason-nvim-dap.nvim',
  },

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local dap, dapui = require('dap'), require('dapui')

    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
      layouts = {
        {
          position = 'left',
          size = 75,
          elements = {
            { id = 'stacks',  size = 0.25 },
            { id = 'watches', size = 0.25 },
            { id = 'scopes',  size = 0.5 },
          },
        },
        {
          position = 'bottom',
          size = 16,
          elements = {
            { id = 'repl', size = 1 },
          },
        },
      },
    })
    require('nvim-dap-virtual-text').setup({})

    require('mason-nvim-dap').setup({
      ensure_installed = { 'delve', 'codelldb' },
      automatic_installation = false,
      handlers = {
        function(config)
          -- all sources with no handler get passed here
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    })

    require('dap-go').setup()

    dap.adapters.go_remote = {
      type = 'server',
      host = '127.0.0.1',
      port = 2345,
    }

    table.insert(dap.configurations.go, {
      type = 'go_remote',
      name = 'Remote Debug',
      request = 'attach',
      mode = 'remote',
    })

    dap.configurations.c = {
      {
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input({ prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' })
        end,
        --program = '${fileDirname}/${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
        terminal = 'integrated'
      }
    }
    dap.configurations.cpp = dap.configurations.c

    -- Keymaps
    --
    -- F-keys mapping:
    -- <f1>..<f12> : <f1>..<f12>
    -- <s-f1>..<s-f12> : <f13>..<f24>
    -- <c-f1>..<c-f12> : <f25>..<f36>
    vim.keymap.set('n', '<f8>', function()
      if vim.fn.filereadable('.vscode/launch.js') then
        require('dap.ext.vscode').load_launchjs()
      end
      dap.continue()
    end)
    vim.keymap.set('n', '<f26>', function() dap.terminate() end)
    vim.keymap.set('n', '<f7>', function() dap.step_over() end)
    vim.keymap.set('n', '<f6>', function() dap.step_into() end)
    vim.keymap.set('n', '<f18>', function() dap.step_out() end)
    vim.keymap.set('n', '<f5>', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<f17>', function() dap.set_breakpoint(vim.fn.input('BP Condition: ')) end)
    vim.keymap.set('n', '<f29>', function() dap.set_breakpoint(nil, nil, vim.fn.input('BP Log Message: ')) end)
    vim.keymap.set('n', '<leader>dr', function() dapui.toggle({ layout = 2 }) end)
    vim.keymap.set('n', '<leader>du', function() dapui.toggle() end)

    vim.keymap.set('n', '<leader>de', function() dapui.eval() end)
    vim.keymap.set('n', '<leader>dc', function()
      vim.ui.input({ prompt = 'Eval: ' }, function(input)
        if input == nil or input == '' then return end
        dapui.eval(input)
      end)
    end)
    vim.keymap.set('n', '<leader>db', function() dapui.float_element('breakpoints') end)

    -- Auto-open repl
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open({ layout = 2 })
    end

    -- Auto-close repl
    -- dap.listeners.before.event_terminated['dapui_config'] = function()
    --   dapui.close({ layout = 2 })
    -- end
    -- dap.listeners.before.event_exited['dapui_config'] = function()
    --   dapui.close({ layout = 2 })
    -- end

    -- Breackpoint highlights and signs
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition',
      { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
  end,
}
