return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
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
        telescope = true,
        bufferline = true,
        notify = false,
        mini = false,
        mason = true,
      },
    })
    vim.cmd('colorscheme catppuccin')
  end,
}
