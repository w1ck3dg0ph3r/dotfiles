return {
  'folke/lazydev.nvim',
  version = '1',

  ft = 'lua',

  opts = {
    -- Disable when a .luarc.json file is found
    enabled = function(root_dir)
      return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
    end,
  },
}
