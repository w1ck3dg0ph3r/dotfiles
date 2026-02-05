return {
  'nvim-treesitter/nvim-treesitter-context',
  version = '1',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    max_lines = 5,
    multiline_threshold = 1,
  },
}
