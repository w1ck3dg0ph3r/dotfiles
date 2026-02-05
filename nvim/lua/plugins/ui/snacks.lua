---@module "snacks"

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    input = {
      win = {
        position = 'float',
        relative = 'cursor',
        on_buf = function()
          vim.api.nvim_feedkeys('', 't', false)
        end,
      }
    },
    picker = {},
  }
}
