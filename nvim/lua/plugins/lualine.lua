return {
  'nvim-lualine/lualine.nvim',

  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'WhoIsSethDaniel/lualine-lsp-progress.nvim',
  },

  priority = 900,

  opts = {
    options = {
      icons_enabled = true,
      theme = 'catppuccin',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },

      disabled_filetypes = {
        statusline = { 'qf', 'NvimTree', 'neo-tree', 'toggleterm' },
        winbar = {},
      },
      ignore_focus = { 'dapui_watches', 'dapui_stacks', 'dapui_breakpoints', 'dapui_scopes', 'neotest-summary', 'neotest-output-panel' },
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 250,
        tabline = 1000,
        winbar = 1000,
      },
    },

    extentions = {
      'nvim-tree',
      'nvim-dap-ui',
      'toggleterm',
    },

    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diagnostics' },
      lualine_c = {
        { 'filename', path = 1, symbols = { modified = ' ●', readonly = '' } },
        {
          'lsp_progress',
          display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
          only_show_attached = true,
          hide = { 'null-ls' },
          spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
          colors = {
            percentage      = '#494d64',
            title           = '#494d64',
            message         = '#494d64',
            spinner         = '#cad3f5',
            lsp_client_name = '#8aadf4',
            use             = true,
          },
          timer = {
            spinner = 250,
          },
        },
      },
      lualine_x = {
        'encoding',
        'fileformat',
        { 'filetype', colored = false },
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },

  },
}
