return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
  },

  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup({})
    require('nvim-dap-virtual-text').setup({})
    require('dap-go').setup()

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
    vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end)
    vim.keymap.set('n', '<leader>du', function() dapui.toggle() end)

    -- Auto-open dap-ui
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    -- Breackpoint highlights and signs
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
  end,
}
