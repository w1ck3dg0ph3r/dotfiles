local M = {}

function M.bootstrap()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if vim.uv.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  end
  vim.opt.rtp:prepend(lazypath)
end

function M.load_plugin_specs(dir, plugins)
  if dir == nil then
    dir = vim.fn.stdpath('config') .. '/lua/plugins'
  end

  if plugins == nil then
    plugins = {}
  end

  for _, fn in pairs(vim.fn.readdir(dir)) do
    local path = dir .. '/' .. fn
    if vim.fn.isdirectory(path) == 1 then
      M.load_plugin_specs(path, plugins)
    elseif fn ~= 'init.lua' and vim.fn.filereadable(path) then
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

return M
