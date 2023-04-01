local util = {}

local function keymap(modes, lhs, rhs, opts, defaults)
  local options = defaults
  if opts then
    for k, v in pairs(opts) do options[k] = v end
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

return util
