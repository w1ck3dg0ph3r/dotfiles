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

function util.load_plugins()
  local dir = vim.fn.stdpath('config') .. '/lua/plugins'
  local plugins = {}
  for _, fn in pairs(vim.fn.readdir(dir)) do
    local path = dir .. '/' .. fn
    if fn ~= 'init.lua' and vim.fn.filereadable(path) then
      local ok, spec = pcall(dofile, path)
      if ok then
        local name
        if spec[1] ~= nil and type(spec[1]) == 'string' then
          name = spec[1]
        else
          name = spec.name
        end
        if name ~= nil then
          plugins[name] = spec
        end
      end
    end
  end
  return plugins
end

return util
