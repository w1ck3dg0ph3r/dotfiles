return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local bufferline = require('bufferline')
    bufferline.setup({
      options = {
        themable = true,
        style_preset = {
          bufferline.style_preset.no_italic,
          bufferline.style_preset.no_bold,
        },
        indicator = {
          style = 'icon',
        },
        show_close_icon = false,
        show_buffer_icons = false,
        color_icons = true,
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
