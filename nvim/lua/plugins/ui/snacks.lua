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
          vim.api.nvim_feedkeys('_', 'n', false)
        end,
      }
    },

    picker = {},

    bigfile = {
      notify = false,
      size = 2.5 * 1024 * 1024,
    },
  }
}
