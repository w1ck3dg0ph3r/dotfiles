local M = {}

local nvimrc_config

function M.config()
  if nvimrc_config ~= nil then
    return nvimrc_config
  end

  nvimrc_config = {}

  local nvimrc_paths = vim.fn.findfile('.nvimrc.lua', '.;', -1)
  if nvimrc_paths == nil or next(nvimrc_paths) == nil then
    return nvimrc_config
  end

  local loaded = nil
  for i = #nvimrc_paths, 1, -1 do
    local nvimrc_path = nvimrc_paths[i]
    local ok, config = pcall(dofile, nvimrc_path)
    if ok then
      if config then
        nvimrc_config = vim.tbl_deep_extend('force', nvimrc_config, config)
      end
      if not loaded then loaded = nvimrc_path end
    else
      vim.print('error loading "' .. nvimrc_path .. '": ' .. config)
    end
  end

  if #nvimrc_paths > 1 then
    vim.print('loaded ' .. #nvimrc_paths .. ' .nvimrc.lua files')
  else
    vim.print('loaded ' .. loaded)
  end

  return nvimrc_config
end

function M.extend_plugin_specs(plugin_specs)
  local cfg = M.config()
  if cfg == nil or cfg.plugins == nil then
    return
  end

  for _, spec in pairs(cfg.plugins) do
    if spec[1] ~= nil and type(spec[1]) == 'string' then
      local name = spec[1]
      if plugin_specs[name] ~= nil then
        -- print('extending plugin ' .. name .. ' with:\n' .. vim.inspect(spec))
        plugin_specs[name] = vim.tbl_deep_extend('force', plugin_specs[name], spec)
      end
    end
  end
end

return M
