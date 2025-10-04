local util = {}

---@class util.keymap.opts
---@field noremap? boolean
---@field nowait? boolean
---@field silent? boolean
---@field script? boolean
---@field expr? boolean
---@field unique? boolean
---@field callback? function
---@field desc? string
---@field replace_keycodes? boolean

---Sets keymap using |vim.keymap.set|.
---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts
---@param defaults vim.keymap.set.Opts
local function keymap(modes, lhs, rhs, opts, defaults)
  local options = defaults
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(modes, lhs, rhs, options)
end

---Defines a |mapping| of |keycodes| to a function or keycodes.
---Default opts is { noremap = true, silent = true }.
---
---Example:
---
--- ```lua
---util.map('n', '<leader>Q', ':qa!')
---```
---
---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts
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

---Returns filepath of the current lua file.
---@return string
function util.script_path()
  local path = debug.getinfo(2, 'S').source:sub(2)
  return path
end

---Returns directory of the current lua file.
---@return string
function util.script_dir()
  local dir = debug.getinfo(2, 'S').source:sub(2):match('(.*)/')
  return dir
end

---Makes forward and backward movements repeatable with ';' and ',' using
---nvim-treesitter.textobjects.repeatable_move.
---@param forward string|function Forward movement keycodes or function.
---@param backward string|function Backward movement keycodes or function.
---@return string|function forward repeatable forward movement.
---@return string|function backward repeatable backward movement.
function util.make_repeatable_move(forward, backward)
  local has_repeat_move, repeatable_move = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
  if not has_repeat_move then
    return forward, backward
  end
  if type(forward) == 'string' then
    local keys = forward
    forward = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
    end
  end
  if type(backward) == 'string' then
    local keys = backward
    backward = function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
    end
  end
  local repeatable = repeatable_move.make_repeatable_move(function(opts)
    if opts.forward then forward() else backward() end
  end)
  return function() repeatable({ forward = true }) end, function() repeatable({ forward = false }) end
end

---Reads entire file into string.
---@param path string
---@return string
function util.read_file(path)
  local file = io.open(path, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    return content
  else
    vim.notify("Error: Could not open file " .. path, vim.log.levels.ERROR)
    return ''
  end
end

---Returns value in table at path or nil.
---
---Example:
---
---```lua
---local enable_coverage = util.tbl_walk(config, 'go', 'test', 'coverage_enabled') or false
---```
---
---@param t table
---@param ... string Path of table keys.
---@return unknown|nil value Value in table at path.
function util.tbl_walk(t, ...)
  if t == nil then return nil end
  local result = t
  local keys = { ... }
  for _, key in ipairs(keys) do
    local nv = result[key]
    if nv ~= nil then result = nv else return nil end
  end
  return result
end

return util
