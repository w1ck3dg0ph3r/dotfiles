return {
  'mfussenegger/nvim-dap',
  -- version = '*', -- Switch to master for now, last tag was over a year ago.
  branck = 'master',

  dependencies = {
    { 'leoluz/nvim-dap-go',           branch = 'main' },
    { 'jay-babu/mason-nvim-dap.nvim', version = '2' },
    { 'igorlfs/nvim-dap-view',        version = '1' },
  },

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local util = require('util')
    local dap = require('dap')

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
      options = {
        initialize_timeout_sec = 30,
      },
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
    if rc.dapconfig ~= nil then
      rc.dapconfig(dap)
    end

    -- Keymaps
    --
    -- F-keys mapping:
    -- <f1>..<f12> : <f1>..<f12>
    -- <s-f1>..<s-f12> : <f13>..<f24>
    -- <c-f1>..<c-f12> : <f25>..<f36>
    -- <c-s-f1>..<c-s-f12> : <f37>..<f48>
    util.map('n', '<f8>', dap.continue, { desc = 'Debug: Continue' })
    util.map('n', '<f5>', dap.toggle_breakpoint, { desc = 'Debug: Toggle breakpoint' })
    util.map('n', '<f17>', function()
      vim.ui.input({ prompt = 'Breakpoint Condition' }, function(cond)
        if cond ~= nil then
          dap.set_breakpoint(cond)
        end
      end)
    end, { desc = 'Debug: Set conditional breakpoint' })
    util.map('n', '<f29>', function()
      vim.ui.input({ prompt = 'Breakpoint Message' }, function(msg)
        if msg ~= nil then
          dap.set_breakpoint(nil, nil, msg)
        end
      end)
    end, { desc = 'Debug: Set logpoint' })

    local view = require('dap-view')
    view.setup({
      winbar = {
        show = true,
        sections = { 'scopes', 'watches', 'exceptions', 'breakpoints', 'threads', 'repl' },
        default_section = 'scopes',
        controls = { enabled = true },
      },
      windows = { size = 0.4, position = 'right' },
      virtual_text = { enabled = false },
    })

    ---@param what dapview.Section
    local view_open = function(what)
      view.open()
      view.jump_to_view(what)
    end

    util.map('n', '<leader>du', view.toggle, { desc = 'Debug: Toggle UI' })
    util.map('n', '<leader>dw', function() view_open('watches') end, { desc = 'Debug: Show watches' })
    util.map('n', '<leader>db', function() view_open('breakpoints') end, { desc = 'Debug: Show breakpoints' })
    util.map('n', '<leader>dr', function() view_open('repl') end, { desc = 'Debug: Show repl' })

    dap.listeners.after.event_initialized['dapui_config'] = function()
      view.open()
      util.pushmap('debug_mode', 'n', {
        { '<f26>', dap.terminate,     { desc = 'Debug: Terminate' } },
        { '<f14>', dap.disconnect,    { desc = 'Debug: Disconnect' } },
        { '<f38>', dap.restart,       { desc = 'Debug: Restart' } },
        { '<f7>',  dap.step_over,     { desc = 'Debug: Step over' } },
        { '<f6>',  dap.step_into,     { desc = 'Debug: Step into' } },
        { '<f18>', dap.step_out,      { desc = 'Debug: Step out' } },
        { '<f4>',  dap.run_to_cursor, { desc = 'Debug: Run to cursor' } },
      })
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      view.close()
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
