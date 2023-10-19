local servers = {
  lua_ls = {},
  bashls = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        semanticTokens = true,
        experimentalPostfixCompletions = true,
        usePlaceholders = false,
        hints = {
          compositeLiteralFields = true,
          parameterNames = true,
        },
        directoryFilters = { '-vendor' },
      },
    },
  },
  volar = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    settings = {},
  },
  eslint = {},
}

local formatters = {
  go = 'gopls',
  lua = 'lua_ls',
  cpp = 'clangd',
}
for _, filetype in ipairs({ 'js', 'ts', 'vue', 'html', 'pug', 'css', 'scss', 'sass', 'json', 'yaml' }) do
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
      function()
        vim.lsp.buf.format({ name = formatters[filetype] })
        vim.api.nvim_feedkeys('zx', 'n', false)
      end,
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
    local lspconfig = require('lspconfig')
    local masonconfig = require('mason-lspconfig')
    mason.setup()

    require('neodev').setup({})

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

        if not lspconfig[server_name] then return end

        lspconfig[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          init_options = servers[server_name] and servers[server_name].init_options or nil,
          filetypes = servers[server_name] and servers[server_name].filetypes or nil,
          settings = servers[server_name] and servers[server_name].settings or nil,
        })
      end,
    })

    local nullls = require('null-ls')
    nullls.setup({
      on_attach = on_attach,
      sources = {
        nullls.builtins.formatting.prettier,
      },
    })
  end,
}
