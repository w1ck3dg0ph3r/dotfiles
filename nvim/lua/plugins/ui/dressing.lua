return {
  -- TODO: Archived, replace with `folke/snacks.nvim`:
  -- https://github.com/stevearc/dressing.nvim/issues/190.
  'stevearc/dressing.nvim',
  branch = 'master',

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
