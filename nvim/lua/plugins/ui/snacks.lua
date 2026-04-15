---@module "snacks"

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    input = {
      win = {
        position = 'float',
        relative = 'cursor',
        enter = true,
        on_buf = function(self)
          local title = self.opts.title and self.opts.title[1] and self.opts.title[1][1] or ''
          if title == ' New Name' then
            vim.api.nvim_feedkeys('_', 'n', false)
          end
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
