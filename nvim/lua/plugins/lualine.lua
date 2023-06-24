return {
  'nvim-lualine/lualine.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons' },

  priority = 900,

  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '|', right = '|' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'NvimTree', 'neo-tree', 'toggleterm' },
        winbar = {},
      },
      ignore_focus = { 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes' },
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
  },
}
