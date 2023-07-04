local servers = {
  lua_ls = {},
  bashls = {},
  gopls = {
    gopls = {
      gofumpt = true,
      usePlaceholders = false,
      directoryFilters = { '-vendor' },
    },
  },
  volar = {},
  eslint = {},
}

local formatters = {
  go = 'gopls',
  lua = 'lua_ls',
}
for _, filetype in ipairs({ 'js', 'ts', 'vue', 'html', 'pug', 'css', 'scss', 'sass' }) do
  formatters[filetype] = 'null-ls'
end

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local has_trouble, _ = pcall(require, 'trouble')
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  if not has_trouble then
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  end
  vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

  local filetype = vim.bo[bufnr].filetype
  if formatters[filetype] ~= nil then
    vim.keymap.set(
      'n', '<leader>f',
      function() vim.lsp.buf.format({ name = formatters[filetype], async = true }) end,
      bufopts
    )
  else
    vim.keymap.set('n', '<leader>f', function() print('no formatter configured for ' .. filetype) end, bufopts)
  end
end

return {
  'neovim/nvim-lspconfig',

  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'jose-elias-alvarez/null-ls.nvim',
    'folke/neodev.nvim',
  },

  config = function()
    local mason = require('mason')
    mason.setup()

    require('neodev').setup({})

    local masonconfig = require('mason-lspconfig')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    masonconfig.setup({
      ensure_installed = vim.tbl_keys(servers)
    })

    masonconfig.setup_handlers({
      function(server_name)
        -- Apply lspconfig from .nvimrc.lua
        local nvimrc = require('nvimrc').config()
        if nvimrc ~= nil and nvimrc.lspconfig ~= nil and nvimrc.lspconfig[server_name] ~= nil then
          servers[server_name] = vim.tbl_deep_extend('force', servers[server_name], nvimrc.lspconfig[server_name])
        end

        require('lspconfig')[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        })
      end,
    })

    local nullls = require('null-ls')
    nullls.setup({
      sources = {
        nullls.builtins.formatting.prettier,
      },
    })
  end,
}
