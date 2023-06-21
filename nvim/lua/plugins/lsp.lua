local servers = {
  lua_ls = {},
  bashls = {},
  gopls = {
    gofumpt = true,
  },
  volar = {},
  eslint = {},
}

local formatters = {
  go = 'gopls',
  vue = 'prettier',
}
for _, filetype in ipairs({ 'js', 'ts', 'vue', 'html', 'pug', 'css', 'scss', 'sass' }) do
  formatters[filetype] = 'null-ls'
end

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

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
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        }
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
