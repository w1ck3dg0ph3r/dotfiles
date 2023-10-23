return {
  'nvim-treesitter/nvim-treesitter-context',

  opts = {
    on_attach = function(bufnr)
      if vim.b[bufnr].big_file then return false end
      return true
    end,
  },
}
