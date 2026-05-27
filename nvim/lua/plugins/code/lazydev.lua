return {
  'folke/lazydev.nvim',
  -- TODO: Pin back to version.
  -- version = '1', -- Temporary switch to the main branch for the lua_ls fix.
  branch = 'main',

  ft = 'lua',

  ---@module "lazydev"
  ---@type lazydev.Config
  opts = {
    -- Disable when a .luarc.json file is found
    enabled = function(root_dir)
      return not vim.uv.fs_stat(root_dir .. '/.luarc.json')
    end,
  },
}
