return {
  'neovim/nvim-lspconfig',

  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'nvimtools/none-ls.nvim',
  },

  config = function()
    local mason = require('mason')
    local masonconfig = require('mason-lspconfig')
    mason.setup()

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
      ts_ls = {
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = require('mason-registry').get_package('vue-language-server'):get_install_path()
                  .. '/node_modules/@vue/language-server',
              languages = { 'vue' },
            }
          },
        },
      },
      volar = {
        settings = {
          vue = {
            complete = {
              casing = {
                tags = 'pascal',
                props = 'camel',
              },
            },
          },
        },
      },
    }

    local formatters = {
      go = 'gopls',
      lua = 'lua_ls',
      cpp = 'clangd',
      c = 'clangd',
      rust = 'rust_analyzer',
      python = 'null-ls',
    }
    for _, filetype in ipairs({ 'typescript', 'javascript', 'vue', 'html', 'pug', 'css', 'scss', 'sass', 'json', 'yaml' }) do
      formatters[filetype] = 'null-ls'
    end

    ---@diagnostic disable-next-line: unused-local
    local on_attach = function(client, bufnr)
      local util = require('util')

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      local has_trouble, _ = pcall(require, 'trouble')

      util.map('n', 'gD', vim.lsp.buf.declaration, bufopts)
      util.map('n', 'gd', vim.lsp.buf.definition, bufopts)
      -- util.map('n', 'K', vim.lsp.buf.hover, bufopts) -- Defined in keymap.lua
      if not has_trouble then
        util.map('n', 'gr', vim.lsp.buf.references, bufopts)
        util.map('n', 'gi', vim.lsp.buf.implementation, bufopts)
      end
      util.map('i', '<c-k>', vim.lsp.buf.signature_help, bufopts)
      util.map('n', '<leader>T', vim.lsp.buf.type_definition, bufopts)
      util.map('n', '<leader>R', vim.lsp.buf.rename, bufopts)
      util.map('n', '<leader>ac', vim.lsp.buf.code_action, bufopts)

      if client.name == 'clangd' then
        util.map('n', '<f4>', ':ClangdSwitchSourceHeader<cr>')
      end

      local filetype = vim.bo[bufnr].filetype
      if formatters[filetype] ~= nil then
        util.map(
          'n', '<leader>f',
          function()
            vim.lsp.buf.format({ name = formatters[filetype] })
          end,
          bufopts
        )
      else
        util.map('n', '<leader>f', function() print('no formatter configured for ' .. filetype) end, bufopts)
      end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities(capabilities))
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    masonconfig.setup({
      ensure_installed = vim.tbl_keys(servers)
    })

    masonconfig.setup_handlers({
      function(server_name)
        -- Apply lspconfig from .nvimrc.lua
        local nvimrc = require('config.nvimrc').config()
        if nvimrc ~= nil and nvimrc.lspconfig ~= nil and nvimrc.lspconfig[server_name] ~= nil then
          servers[server_name] = vim.tbl_deep_extend('force', servers[server_name], nvimrc.lspconfig[server_name])
        end

        local lspconfig = require('lspconfig')
        if not lspconfig[server_name] then
          print('lsp config not found for: ' .. server_name)
          return
        end

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
        nullls.builtins.formatting.black,
        nullls.builtins.formatting.isort,
      },
    })
  end,
}
