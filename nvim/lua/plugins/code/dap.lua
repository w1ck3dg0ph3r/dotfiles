return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-neotest/nvim-nio',
  },

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local util = require('util')
    local dap, dapui = require('dap'), require('dapui')

    local layouts = {
      sidebar = 1,
      repl = 2,
    }

    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
      layouts = {
        {
          position = 'left',
          size = 75,
          elements = {
            { id = 'scopes',  size = 0.5 },
            { id = 'watches', size = 0.25 },
            { id = 'stacks',  size = 0.25 },
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
      ensure_installed = {},
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
        name = 'LLDB: Current File',
        type = 'codelldb',
        request = 'launch',
        program = '${fileDirname}/${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
      }
    }
    dap.configurations.cpp = dap.configurations.c

    -- Apply dapconfig from .nvimrc.lua
    local rc = require('config.nvimrc').config()
    if rc.dapconfig ~= nil and type(rc.dapconfig) == 'function' then
      rc.dapconfig(dap)
    end

    -- Keymaps
    --
    -- F-keys mapping:
    -- <f1>..<f12> : <f1>..<f12>
    -- <s-f1>..<s-f12> : <f13>..<f24>
    -- <c-f1>..<c-f12> : <f25>..<f36>
    -- <c-s-f1>..<c-s-f12> : <f37>..<f48>
    util.map('n', '<f8>', dap.continue)
    util.map('n', '<f32>', function() require('dap-go').debug_test() end)
    util.map('n', '<f5>', dap.toggle_breakpoint)
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
    util.map('n', '<leader>dr', function() dapui.toggle({ layout = layouts.repl }) end)
    util.map('n', '<leader>du', function()
      dapui.toggle({ layout = layouts.sidebar })
      if require('dapui.windows').layouts[layouts.sidebar]:is_open() then
        dapui.open({ layout = layouts.repl })
      else
        dapui.close({ layout = layouts.repl })
      end
    end)

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
      dapui.open({ layout = layouts.repl })

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
      if not require('dapui.windows').layouts[layouts.sidebar]:is_open() then
        dapui.close({ layout = layouts.repl })
      end
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
