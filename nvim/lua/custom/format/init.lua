return {
  dir = require('util').script_dir(),
  name = 'custom-format',

  dependencies = {
    'nvimtools/none-ls.nvim',
  },

  config = function()
    local nullls = require('null-ls')
    nullls.setup({
      timeout_ms = 5000,
      sources = {
        nullls.builtins.formatting.prettier,
        nullls.builtins.formatting.black,
        nullls.builtins.formatting.isort,
      },
    })

    local util = require('util')
    util.map('n', '<leader>f', function()
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo[buf].filetype
      local has_null_ls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0
      vim.lsp.buf.format({
        timeout_ms = 5000,
        filter = function(client)
          local allow = false
          if has_null_ls then
            allow = client.name == 'null-ls'
          else
            allow = client.name ~= 'null-ls'
          end
          if allow then
            vim.print('format: ' .. client.name)
          end
          return allow
        end,
      })
    end)
  end,
}
