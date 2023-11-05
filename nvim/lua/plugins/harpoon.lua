return {
  'ThePrimeagen/harpoon',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    require('harpoon').setup({})
    local util = require('util')

    util.map('n', 'mm', function() require('harpoon.ui').toggle_quick_menu() end)
    util.map('n', 'ma', function() require('harpoon.mark').add_file() end)
    util.map('n', 'mn', function() require('harpoon.ui').nav_next() end)
    util.map('n', 'mp', function() require('harpoon.ui').nav_prev() end)

    for i = 1, 9, 1 do
      util.map('n', 'm' .. i, function() require('harpoon.ui').nav_file(i) end)
    end
  end
}
