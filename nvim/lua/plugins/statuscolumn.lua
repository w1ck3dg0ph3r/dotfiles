return {
  'luukvbaal/statuscol.nvim',

  config = function()
    local statuscol = require('statuscol')
    local builtin = require('statuscol.builtin')

    statuscol.setup({
      segments = {
        {
          sign = {
            name = { 'GitSigns' },
            maxwidth = 1,
            auto = true,
          },
        },
        { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
        {
          sign = {
            name = { 'Diagnostic' },
            maxwidth = 1,
            auto = true,
          },
          click = 'v:lua.ScSa',
        },
        {
          sign = {
            name = { 'Dap' },
            maxwidth = 1,
            auto = true,
          },
          click = 'v:lua.ScSa',
        },
        {
          sign = {
            name = { '.*' },
            maxwidth = 1,
            auto = false
          },
          click = 'v:lua.ScSa'
        },
        { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa', },
        {
          sign = { name = { 'coverage' }, auto = true },
        },
      },
    })
  end,
}
