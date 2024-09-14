return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-neotest/nvim-nio',
  },

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local util = require('util')
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

    require('nvim-dap-virtual-text').setup({ enabled = false })

    require('mason-nvim-dap').setup({
      ensure_installed = { 'delve', 'codelldb' },
      automatic_installation = false,
      handlers = {
        function(config)
          -- all sources with no handler get passed here
          require('mason-nvim-dap').default_setup(config)
        end,
        delve = function(_) --[[ let dap-go do it's thing ]] end,
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
    vim.api.nvim_create_user_command('GoDebugTest', require('dap-go').debug_test, {})
    vim.api.nvim_create_user_command('GoDebugLastTest', require('dap-go').debug_last_test, {})

    dap.configurations.c = {
      {
        type = 'codelldb',
        name = 'LLDB',
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
    -- <c-s-f1>..<c-s-f12> : <f37>..<f48>
    util.map('n', '<f8>', function()
      if vim.fn.filereadable('.vscode/launch.js') then
        require('dap.ext.vscode').load_launchjs()
      end
      dap.continue()
    end)
    util.map('n', '<f32>', function()
      require('dap-go').debug_test()
    end)
    util.map('n', '<f5>', function() dap.toggle_breakpoint() end)
    util.map('n', '<f17>', function()
      vim.ui.input({ prompt = 'Breakpoint Condition' }, function(cond)
        if cond ~= nil then
          dap.set_breakpoint(cond)
        end
      end)
    end)
    util.map('n', '<f29>', function()
      vim.ui.input({ prompt = 'Breakpoint Message' }, function(msg)
        if msg ~= nil then
          dap.set_breakpoint(nil, nil, msg)
        end
      end)
    end)
    util.map('n', '<leader>dr', function() dapui.toggle({ layout = 2 }) end)
    util.map('n', '<leader>du', function() dapui.toggle() end)

    local float_opts = {
      width = 80,
      height = 40,
      enter = true,
      position = 'center',
    }
    util.map('n', '<leader>db', function()
      dapui.float_element('breakpoints', float_opts)
    end)
    util.map('n', '<leader>dw', function()
      dapui.float_element('watches', float_opts)
    end)
    util.map('n', '<leader>ds', function()
      dapui.float_element('stacks', float_opts)
    end)

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open({ layout = 2 })

      util.pushmap('debug_mode', 'n', {
        { '<f26>', dap.terminate },
        { '<f14>', dap.disconnect },
        { '<f38>', dap.restart },
        { '<f7>',  dap.step_over },
        { '<f6>',  dap.step_into },
        { '<f18>', dap.step_out },
        { '<f4>',  dap.run_to_cursor },
        -- { 'K',     dapui.eval }, -- Defined in keymap.lua
        { '<leader>dc',
          function()
            vim.ui.input({ prompt = 'Eval: ' }, function(input)
              if input == nil or input == '' then return end
              dapui.eval(input)
            end)
          end
        },
      })
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close({ layout = 2 })
      util.popmap('debug_mode', 'n')
    end

    dap.listeners.before.event_exited['dapui_config'] = dap.listeners.before.event_terminated['dapui_config']

    -- Breakpoint highlights and signs
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
    vim.api.nvim_set_hl(0, 'DapRejected', { ctermbg = 0, fg = '#333853' })
    local sign = vim.fn.sign_define
    sign('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    sign('DapBreakpointRejected', { text = '', texthl = 'DapRejected', linehl = '', numhl = '' })
    sign('DapBreakpointCondition', { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
    sign('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' })
    sign('DapStopped', { text = '', texthl = 'DapStopped' })
  end,
}
