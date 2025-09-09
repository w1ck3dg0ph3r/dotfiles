return {
  'cbochs/grapple.nvim',

  config = function()
    local grapple = require('grapple')
    grapple.setup({
      scope = 'git_branch',
    });

    local util = require('util')
    util.map('n', 'mm', grapple.toggle_tags)
    util.map('n', 'ma', grapple.tag)
    util.map('n', 'md', grapple.untag)
    for i = 1, 9, 1 do
      util.map('n', 'm' .. i, function() grapple.select({ index = i }) end)
    end
  end,
}
