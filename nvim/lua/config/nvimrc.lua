---@module "lazy.types"
---@module "conform.types"
---@module "dap"

local nvimrc = {}

---Local nvim configuration.
---@class nvimrc.Config
---@field plugins? LazyPluginSpec[] Plugin spec overrides. Those will be applied using |vim.tbl_deep_extend|.
---@field lspconfig? table<string,vim.lsp.Config> LSP configuration overrides.
---@field dapconfig? fun(dap: nvimrc.DAP) DAP configuration overrides.
---@field conform? conform.setupOpts Conform configuration overrides.
---@field go? nvimrc.Go Configuration of custom.go module.

---@class nvimrc.DAP
---@field adapters table<string, dap.Adapter|dap.AdapterFactory>
---@field configurations table<string, dap.Configuration[]>

---@class nvimrc.Go
---@field test? nvimrc.Go.Test

---@class nvimrc.Go.Test
---@field coverage_enabled boolean Enable coverage for neotest.
---@field coverage_file string Name of the coverage report file, default is 'coverage.out'.

---Cached nvimrc config.
---@type nvimrc.Config
local nvimrc_config

---Returns local nvim configuration loaded from .nvimrc.lua file found in
---current directory and any parent directory.
---@return nvimrc.Config
function nvimrc.config()
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

function nvimrc.extend_plugin_specs(plugin_specs)
  local cfg = nvimrc.config()
  if cfg == nil or cfg.plugins == nil then
    return
  end

  for _, spec in pairs(cfg.plugins) do
    local name = spec[1]
    if name ~= nil and type(name) == 'string' then
      if plugin_specs[name] ~= nil then
        -- print('extending plugin ' .. name .. ' with:\n' .. vim.inspect(spec))
        plugin_specs[name] = vim.tbl_deep_extend('force', plugin_specs[name], spec)
      end
    end
  end
end

return nvimrc
