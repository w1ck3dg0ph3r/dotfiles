local M = {}

local nvimrc_config

function M.config()
  if nvimrc_config ~= nil then
    return nvimrc_config
  end

  local nvimrc_path = vim.fn.findfile('.nvimrc.lua', '.;')
  if nvimrc_path ~= nil and nvimrc_path ~= '' then
    local ok, config = pcall(dofile, nvimrc_path)
    if ok then
      nvimrc_config = config or {}
    else
      print('error loading "' .. nvimrc_path .. '": ' .. config)
      nvimrc_config = {}
    end
  end

  return nvimrc_config
end

function M.extend_plugin_specs(plugin_specs)
  if nvimrc_config == nil or nvimrc_config.plugins == nil then
    return
  end

  for _, spec in pairs(nvimrc_config.plugins) do
    if spec[1] ~= nil and type(spec[1]) == 'string' then
      local name = spec[1]
      if plugin_specs[name] ~= nil then
        plugin_specs[name] = vim.tbl_deep_extend('force', plugin_specs[name], spec)
      end
    end
  end
end

return M
