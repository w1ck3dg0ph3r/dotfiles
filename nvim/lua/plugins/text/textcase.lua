return {
  'johmsalas/text-case.nvim',
  version = '1',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local tc = require('textcase')
    local util = require('util')

    util.map('n', 'gau', function() tc.current_word('to_upper_case') end, { desc = 'Convert to UPPER CASE' })
    util.map('n', 'gal', function() tc.current_word('to_lower_case') end, { desc = 'Convert to lower case' })
    util.map('n', 'gas', function() tc.current_word('to_snake_case') end, { desc = 'Convert to snake_case' })
    util.map('n', 'gad', function() tc.current_word('to_dash_case') end, { desc = 'Convert to dash-case' })
    util.map('n', 'gan', function() tc.current_word('to_constant_case') end, { desc = 'Convert to CONSTANT_CASE' })
    util.map('n', 'gac', function() tc.current_word('to_camel_case') end, { desc = 'Convert to camelCase' })
    util.map('n', 'gap', function() tc.current_word('to_pascal_case') end, { desc = 'Convert to PascalCase' })

    util.map('n', 'gou', function() tc.operator('to_upper_case') end, { desc = 'Convert to UPPER CASE' })
    util.map('n', 'gol', function() tc.operator('to_lower_case') end, { desc = 'Convert to lower case' })
    util.map('n', 'gos', function() tc.operator('to_snake_case') end, { desc = 'Convert to snake_case' })
    util.map('n', 'god', function() tc.operator('to_dash_case') end, { desc = 'Convert to dash-case' })
    util.map('n', 'gon', function() tc.operator('to_constant_case') end, { desc = 'Convert to CONSTANT_CASE' })
    util.map('n', 'goc', function() tc.operator('to_camel_case') end, { desc = 'Convert to camelCase' })
    util.map('n', 'gop', function() tc.operator('to_pascal_case') end, { desc = 'Convert to PascalCase' })
  end,
}
