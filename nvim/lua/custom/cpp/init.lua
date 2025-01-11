return {
  dir = vim.fn.stdpath('config') .. '/lua/custom/cpp',
  name = '-custom-cpp',
  dependencies = {
    'L3MON4D3/LuaSnip',
  },
  ft = 'cpp',
  config = function()
    local luasnip = require('luasnip')
    local extras = require('luasnip.extras')

    local snip = luasnip.snippet
    local node = luasnip.snippet_node
    local text = luasnip.text_node
    local insert = luasnip.insert_node
    local func = luasnip.function_node
    local choice = luasnip.choice_node
    local dynamic = luasnip.dynamic_node
    local rep = extras.rep

    local function guard_name()
      local fn = vim.fs.basename(vim.api.nvim_buf_get_name(0))
      local guard = string.upper(fn:gsub('%.', '_'))
      return node(nil, { insert(1, guard) })
    end

    luasnip.add_snippets("cpp", {
      snip({
        trig = 'hguard',
        name = 'C++ header include guard',
      }, {
        text('#ifndef '), dynamic(1, guard_name), text({ '', '' }),
        text('#define '), rep(1), text({ '', '', '' }),
        insert(0),
        text({ '', '', '#endif // !' }), rep(1), text({ '' }),
      })
    })
  end,
}
