return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        config = function()
        require('catppuccin').setup({
            flavour = 'mocha',
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                notify = false,
                mini = false,
            },
        })
        vim.cmd('colorscheme catppuccin')
        end,
    },
}
