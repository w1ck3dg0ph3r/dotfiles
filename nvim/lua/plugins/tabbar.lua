return {
  'akinsho/bufferline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      close_command = 'bw|bp',
      offsets = {
        { filetype = 'NvimTree', text = 'File Tree', highlight = 'Directory', separator = false },
        { filetype = 'neo-tree', text = 'File Tree', highlight = 'Directory', separator = false },
      },
    },
    highlights = {
      buffer_selected = {
        italic = false,
      },
    },
  },
}