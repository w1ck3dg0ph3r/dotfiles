return {
  'nvim-treesitter/nvim-treesitter-context',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    max_lines = 5,
    multiline_threshold = 1,
    on_attach = function(bufnr)
      if vim.b[bufnr].big_file then return false end
      return true
    end,
  },
}
