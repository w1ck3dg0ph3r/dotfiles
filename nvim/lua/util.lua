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

function util.make_repeatable_move(forward, backward)
  local has_repeat_move, ts_repeat_move = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
  if not has_repeat_move then
    return forward, backward
  end
  if type(forward) == 'string' then
    local keys = forward
    forward = function ()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
    end
  end
  if type(backward) == 'string' then
    local keys = backward
    backward = function ()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
    end
  end
  return ts_repeat_move.make_repeatable_move_pair(forward, backward)
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
