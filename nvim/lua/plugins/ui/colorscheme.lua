return {
  'catppuccin/nvim',
  branch = 'main',

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
        transparent = false,
        solid = true,
      },
      auto_integrations = true,
    })
    vim.cmd('colorscheme catppuccin')
  end,
}
