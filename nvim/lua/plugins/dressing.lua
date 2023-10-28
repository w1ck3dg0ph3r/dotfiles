return {
  'stevearc/dressing.nvim',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    input = {
      start_in_insert = false,
    },
  },
}
