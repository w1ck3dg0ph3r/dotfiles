local M = {}

local nvimrc_config

M.config = function()
  if nvimrc_config ~= nil then
    return nvimrc_config
  end

  local ok, config = pcall(dofile, vim.fn.getcwd() .. '/.nvimrc.lua')
  if ok then
    nvimrc_config = config
  end

  return nvimrc_config
end

return M
