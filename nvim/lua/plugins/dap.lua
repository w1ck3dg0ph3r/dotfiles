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

    dapui.setup()
    require('nvim-dap-virtual-text').setup()
    require('dap-go').setup()

    -- Keymaps
    vim.keymap.set('n', '<f8>', function() dap.continue() end)
    vim.keymap.set('n', '<c-f12>', function() dap.terminate() end)
    vim.keymap.set('n', '<f7>', function() dap.step_over() end)
    vim.keymap.set('n', '<f6>', function() dap.step_into() end)
    vim.keymap.set('n', '<s-f8>', function() dap.step_out() end)
    vim.keymap.set('n', '<f5>', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<s-f5>', function() dap.set_breakpoint(vim.fn.input('BP Condition: ')) end)
    vim.keymap.set('n', '<c-f5>', function() dap.set_breakpoint(nil, nil, vim.fn.input('BP Log Message: ')) end)
    vim.keymap.set('n', '<leader>dr', function() dap.repl.open() end)
    vim.keymap.set('n', '<leader>du', function() dapui.toggle() end)

    -- Auto-open dap-ui
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.after.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.after.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Breackpoint highlights and signs
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
  end,
}
