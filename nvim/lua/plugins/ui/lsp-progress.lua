return {
  'linrongbin16/lsp-progress.nvim',
  version = '1',

  config = function()
    local lspprogres = require('lsp-progress')

    lspprogres.setup({
      spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },

      format = function(client_messages)
        if #client_messages > 0 then
          return " " .. table.concat(client_messages, " ")
        end
        return ""
      end,
    })
  end,
}
