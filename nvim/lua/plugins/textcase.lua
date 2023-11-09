return {
  'johmsalas/text-case.nvim',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  config = function()
    local tc = require('textcase')
    local util = require('util')

    util.map('n', 'gau', function() tc.current_word('to_upper_case') end)
    util.map('n', 'gal', function() tc.current_word('to_lower_case') end)
    util.map('n', 'gas', function() tc.current_word('to_snake_case') end)
    util.map('n', 'gad', function() tc.current_word('to_dash_case') end)
    -- util.map('n', 'gan', function() tc.current_word('to_constant_case') end)
    -- util.map('n', 'gad', function() tc.current_word('to_dot_case') end)
    -- util.map('n', 'gaa', function() tc.current_word('to_phrase_case') end)
    util.map('n', 'gac', function() tc.current_word('to_camel_case') end)
    util.map('n', 'gap', function() tc.current_word('to_pascal_case') end)
    -- util.map('n', 'gat', function() tc.current_word('to_title_case') end)
    -- util.map('n', 'gaf', function() tc.current_word('to_path_case') end)

    -- util.map('n', 'gaU', function() tc.lsp_rename('to_upper_case') end)
    -- util.map('n', 'gaL', function() tc.lsp_rename('to_lower_case') end)
    -- util.map('n', 'gaS', function() tc.lsp_rename('to_snake_case') end)
    -- util.map('n', 'gaD', function() tc.lsp_rename('to_dash_case') end)
    -- util.map('n', 'gaN', function() tc.lsp_rename('to_constant_case') end)
    -- util.map('n', 'gaD', function() tc.lsp_rename('to_dot_case') end)
    -- util.map('n', 'gaA', function() tc.lsp_rename('to_phrase_case') end)
    -- util.map('n', 'gaC', function() tc.lsp_rename('to_camel_case') end)
    -- util.map('n', 'gaP', function() tc.lsp_rename('to_pascal_case') end)
    -- util.map('n', 'gaT', function() tc.lsp_rename('to_title_case') end)
    -- util.map('n', 'gaF', function() tc.lsp_rename('to_path_case') end)

    util.map('n', 'geu', function() tc.operator('to_upper_case') end)
    util.map('n', 'gel', function() tc.operator('to_lower_case') end)
    util.map('n', 'ges', function() tc.operator('to_snake_case') end)
    util.map('n', 'ged', function() tc.operator('to_dash_case') end)
    -- util.map('n', 'gen', function() tc.operator('to_constant_case') end)
    -- util.map('n', 'ged', function() tc.operator('to_dot_case') end)
    -- util.map('n', 'gea', function() tc.operator('to_phrase_case') end)
    util.map('n', 'gec', function() tc.operator('to_camel_case') end)
    util.map('n', 'gep', function() tc.operator('to_pascal_case') end)
    -- util.map('n', 'get', function() tc.operator('to_title_case') end)
    -- util.map('n', 'gef', function() tc.operator('to_path_case') end)
  end,
}
