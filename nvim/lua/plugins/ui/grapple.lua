return {
  'cbochs/grapple.nvim',
  version = '*',

  event = 'UIEnter',

  opts = {
    scope = 'git_branch',
  },

  config = function(_, opts)
    local grapple = require('grapple')
    grapple.setup(opts);

    local util = require('util')
    util.map('n', 'mm', grapple.toggle_tags, { desc = 'Grapple: Toggle' })
    util.map('n', 'ma', grapple.tag, { desc = 'Grapple: Add mark' })
    util.map('n', 'md', grapple.untag, { desc = 'Grapple: Delete mark' })
    for i = 1, 9, 1 do
      util.map('n', 'm' .. i, function()
        grapple.select({ index = i })
      end, { desc = 'Grapple: Goto mark ' .. i })
    end
  end,
}
