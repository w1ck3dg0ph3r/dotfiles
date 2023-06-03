return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('bufferline').setup({
      options = {
        themable = true,
        indicator = {
          style = 'none',
        },
        show_close_icon = false,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        close_command = ':Bdelete',
        offsets = {
          { filetype = 'NvimTree', text = 'File Tree', highlight = 'Directory', separator = false },
          { filetype = 'neo-tree', text = 'File Tree', highlight = 'Directory', separator = false },
        },
      },
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
    })
  end,
}
