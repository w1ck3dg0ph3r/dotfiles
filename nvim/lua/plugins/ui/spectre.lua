return {
  'nvim-pack/nvim-spectre',
  branch = 'master',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    local spectre = require('spectre')
    local util = require('util')

    local has_trouble, _ = pcall(require, 'trouble')

    spectre.setup({
      open_cmd = 'vnew',
      mapping = {
        ['send_to_qf'] = {
          map = "<leader>f",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf(); require('spectre').toggle()<cr>",
          desc = "send all items to quickfix"
        },
      },
      use_trouble_qf = has_trouble,
    })
    util.map('n', '<leader>S', function() spectre.toggle() end)
  end,
}
