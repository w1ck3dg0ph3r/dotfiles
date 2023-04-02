return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup({
      sort_by = 'case_sensitive',
      view = {
        mappings = {
          custom_only = false,
          list = {
            { key = '<space>', action = 'edit' },
            { key = 'E', action = 'expand_all' },
            { key = 'H', action = 'collapse_all' },
          },
        },
      },
      diagnostics = { enable = true },
    })

    local api = require('nvim-tree.api')

    -- Open tree on start
    local function open_nvim_tree(data)
      -- buffer is a directory
      local directory = vim.fn.isdirectory(data.file) == 1
      if not directory then
        return
      end
      -- change to the directory
      vim.cmd.cd(data.file)
      -- open the tree
      api.tree.open()
    end
    vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

    -- Follow current buffer
    local function auto_update_path()
      local buf = vim.api.nvim_get_current_buf()
      local bufname = vim.api.nvim_buf_get_name(buf)
      if vim.fn.isdirectory(bufname) or vim.fn.isfile(bufname) then
        require('nvim-tree.api').tree.find_file(vim.fn.expand('%:p'))
      end
    end
    vim.api.nvim_create_autocmd('BufEnter', { callback = auto_update_path })

    vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>')
  end,
}
