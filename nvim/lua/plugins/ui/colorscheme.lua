return {
  'catppuccin/nvim',
  name = 'catppuccin',

  lazy = false,
  priority = 1000,

  config = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      no_bold = false,
      no_italic = false,
      no_underline = false,
      float = {
        transparent = true,
        solid = true,
      },
      auto_integrations = true,
    })
    vim.cmd('colorscheme catppuccin')
  end,
}
