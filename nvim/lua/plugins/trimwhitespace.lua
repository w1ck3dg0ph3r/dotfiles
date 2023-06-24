return {
  'cappyzawa/trim.nvim',

  event = 'BufWritePre',

  opts = {
    ft_blocklist = { 'markdown' },
    trim_on_write = true,
    trim_trailing = true,
    trim_last_line = true,
    trim_first_line = true,
  },
}
