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
        treesitter_context = true,
        telescope = {
          enabled = true,
          style = 'classic',
        },
        harpoon = true,
        lsp_trouble = true,
        bufferline = true,
        mason = true,
        dap = true,
        neotest = true,
      },
    })
    vim.cmd('colorscheme catppuccin')
  end,
}
