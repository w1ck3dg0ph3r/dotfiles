return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {'nvim-tree/nvim-web-devicons'},
  config = function()
    require('nvim-tree').setup({
      sort_by = 'case_sensitive',
    })

    local function open_nvim_tree(data)
      -- buffer is a directory
      local directory = vim.fn.isdirectory(data.file) == 1
      if not directory then
        return
      end
      -- change to the directory
      vim.cmd.cd(data.file)
      -- open the tree
      require('nvim-tree.api').tree.open()
    end

    vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

    vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle<cr>')
  end,
}

-- return {
--   'nvim-neo-tree/neo-tree.nvim',
--   dependencies = {'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim', 'nvim-tree/nvim-web-devicons'},
--   keys = {
--     {'<leader>t', '<cmd>Neotree toggle<cr>', desc='NeoTree'},
--   },
--   config = function()
--     require('neo-tree').setup({
--       filesystem = {
--         follow_current_file = true,
--       },
--       source_selector = {
--         winbar = false,
--         statusline = false,
--       }
--     })
--   end,
-- }
