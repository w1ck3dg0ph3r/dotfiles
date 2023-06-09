local M = {}

local nvimrc_config

M.config = function()
  if nvimrc_config ~= nil then
    return nvimrc_config
  end

  local nvimrc_path = vim.fn.findfile('.nvimrc.lua', '.;')
  if nvimrc_path ~= nil and nvimrc_path ~= '' then
    local ok, config = pcall(dofile, nvimrc_path)
    if ok then
      nvimrc_config = config
    else
      print('error loading "' .. nvimrc_path .. '": ' .. config)
      nvimrc_config = {}
    end
  end

  return nvimrc_config
end

return M
