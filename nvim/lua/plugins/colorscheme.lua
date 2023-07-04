return {
  'catppuccin/nvim',
  name = 'catppuccin',

  lazy = false,
  priority = 1000,

  config = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      no_bold = true,
      no_italic = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = {
          enabled = true,
          style = 'classic',
        },
        lsp_trouble = true,
        bufferline = true,
        mason = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
      },
    })
    vim.cmd('colorscheme catppuccin')
  end,
}
