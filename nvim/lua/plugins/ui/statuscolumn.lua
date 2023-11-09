return {
  'luukvbaal/statuscol.nvim',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local statuscol = require('statuscol')
    local builtin = require('statuscol.builtin')

    statuscol.setup({
      relculright = true,

      ft_ignore = {
        'alpha',
        'NvimTree',
        'help',
        'Trouble',
        'dapui_watches',
        'dapui_stacks',
        'dapui_breakpoints',
        'dapui_scopes',
        'dap-repl',
        'neotest-summary',
        'neotest-output',
        'neotest-output-panel',
      },
      bt_ignore = { 'terminal' },

      segments = {
        { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
        {
          sign = {
            namespace = { 'gitsigns' },
            maxwidth = 1,
            colwidth = 1,
            auto = true,
          },
        },
        {
          sign = {
            name = { 'Diagnostic' },
            maxwidth = 3,
            auto = true,
          },
        },
        {
          sign = {
            name = { '.*' },
            maxwidth = 3,
            colwidth = 1,
            auto = true,
          },
        },
        {
          sign = {
            name = { 'Dap' },
            maxwidth = 1,
            colwidth = 1,
            auto = true,
          },
        },
        {
          text = { builtin.lnumfunc },
          click = 'v:lua.ScLa',
        },
        {
          text = { '│' },
          hl = 'Whitespace',
        },
        {
          sign = {
            name = { 'coverage' },
            auto = true
          },
        },
      },
    })
  end,
}
