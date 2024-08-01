return {
  'nvim-pack/nvim-spectre',

  dependencies = {
    'nvim-lua/plenary.nvim'
  },

  config = function()
    local spectre = require('spectre')
    local util = require('util')
    spectre.setup({
      mapping = {
        ['send_to_qf'] = {
          map = "<leader>f",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf(); require('spectre').toggle()<cr>",
          desc = "send all items to quickfix"
        },
      },
    })
    util.map('n', '<leader>S', function() spectre.toggle() end)
  end,
}
