local luasnip = require('luasnip')

local snip = luasnip.snippet
local node = luasnip.snippet_node
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node
local choice = luasnip.choice_node
local dynamicn = luasnip.dynamic_node

luasnip.add_snippets("go", {
  snip({
    trig = 'iferr',
    name = 'if err != nil',
    descr = 'Go propagate error',
  }, {
    text({ 'if err != nil {', '\treturn ' }),
    insert(1),
    text({ 'err', '}', '' }),
    insert(0),
  })
})
