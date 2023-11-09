return {
  'stevearc/dressing.nvim',

  event = { 'BufNewFile', 'BufReadPost', 'FileReadPost' },

  opts = {
    input = {
      start_in_insert = true,
      insert_only = false,

      get_config = function(opts)
        if opts.prompt == 'New Name: ' then
          return { start_in_insert = false }
        end
      end,
    },
  },
}
