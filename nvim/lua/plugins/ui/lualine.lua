local function get_active_lsps()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then return '' end
  local names = {}
  for _, c in ipairs(clients) do table.insert(names, c.name) end
  return table.concat(names, ', ')
end

---@type LazyPluginSpec
local M = {
  'nvim-lualine/lualine.nvim',
  branch = 'master',

  event = 'UIEnter',

  opts = {
    options = {
      icons_enabled = true,
      theme = 'catppuccin-nvim',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },

      disabled_filetypes = {
        statusline = { 'alpha', 'qf', 'toggleterm', 'Trouble' },
        winbar = {},
      },
      ignore_focus = {
        'dapui_watches',
        'dapui_stacks',
        'dapui_breakpoints',
        'dapui_scopes',
        'neotest-summary',
        'neotest-output-panel',
      },
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 250,
        tabline = 1000,
        winbar = 1000,
      },
    },

    extentions = {
      'nvim-dap-ui',
      'toggleterm',
    },

    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } },
      },
      lualine_c = {
        { 'filename', path = 1, symbols = { modified = ' ●', readonly = '' } },
        function() return require('lsp-progress').progress() end,
      },
      lualine_x = {
        'encoding',
        'fileformat',
        { 'filetype', colored = false },
        { get_active_lsps, icon = ' ' },
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },

  },
}

return M
