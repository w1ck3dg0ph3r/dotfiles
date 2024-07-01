local util = {}

local function keymap(modes, lhs, rhs, opts, defaults)
  local options = defaults
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(modes, lhs, rhs, options)
end

function util.map(modes, lhs, rhs, opts)
  keymap(modes, lhs, rhs, opts, {
    noremap = true,
    silent = true,
  })
end

function util.remap(modes, lhs, rhs, opts)
  keymap(modes, lhs, rhs, opts, {
    silent = true,
  })
end

function util.delmap(modes, lhs, opts)
  vim.keymap.del(modes, lhs, opts)
end

function util.pushmap(name, mode, mappings)
  require('stackmap').push(name, mode, mappings)
end

function util.popmap(name, mode)
  require('stackmap').pop(name, mode)
end

function util.tbl_walk(t, ...)
  if t == nil then return end
  local result = t
  local keys = { ... }
  for _, key in ipairs(keys) do
    local nv = result[key]
    if nv ~= nil then result = nv else return end
  end
  return result
end

return util
