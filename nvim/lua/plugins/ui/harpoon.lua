local use_v1 = true

local v1config = {
  'ThePrimeagen/harpoon',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    require('harpoon').setup({
      menu = {
        width = 100,
      }
    })
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

local v2config = {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()
    local util = require('util')

    util.map('n', 'mm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    util.map('n', 'ma', function() harpoon:list():add() end)
    util.map('n', 'mn', function() harpoon:list():next() end)
    util.map('n', 'mp', function() harpoon:list():prev() end)

    for i = 1, 9, 1 do
      util.map('n', 'm' .. i, function() harpoon:list():select(i) end)
    end
  end
}

if use_v1 then
  return v1config
else
  return v2config
end
