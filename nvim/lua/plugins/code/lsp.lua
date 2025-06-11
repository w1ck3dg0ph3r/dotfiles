return {
  'neovim/nvim-lspconfig',

  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'nvimtools/none-ls.nvim',
  },

  config = function()
    local mason = require('mason')
    local masonconfig = require('mason-lspconfig')
    mason.setup()
    masonconfig.setup()

    vim.lsp.config('clangd', {
      cmd = { 'clangd', '--header-insertion=never' },
    })

    vim.lsp.config('ts_ls', {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      init_options = {
        plugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fn.expand('$MASON/packages/vue-language-server/node_modules/@vue/language-server'),
            languages = { 'vue' },
          }
        },
      },
    })

    vim.lsp.config('vue_ls', {
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
    })

    vim.lsp.config('gopls', {
      settings = {
        gopls = {
          gofumpt = false,
          semanticTokens = true,
          experimentalPostfixCompletions = true,
          usePlaceholders = false,
          hints = {
            compositeLiteralFields = true,
            parameterNames = true,
          },
        },
      },
    })

    -- Apply lspconfig from .nvimrc.lua
    local nvimrc = require('config.nvimrc').config()
    if nvimrc ~= nil and nvimrc.lspconfig ~= nil then
      for key, value in pairs(nvimrc.lspconfig) do
        vim.lsp.config(key, value)
      end
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp.group', {}),
      callback = function(args)
        local util = require('util')
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufopts = { noremap = true, silent = true, buffer = args.buf }
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

        if client:supports_method('textDocument/foldingRange') then
          local win = vim.api.nvim_get_current_win()
          vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end

        if client.name == 'clangd' then
          util.map('n', '<f4>', ':LspClangdSwitchSourceHeader<cr>')
        end

        if client:supports_method('textDocument/formatting') then
          util.map('n', '<leader>f', function()
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 5000 })
          end, bufopts)
        end
      end,
    })

    vim.lsp.enable({
      'bashls',
      'clangd',
      'gopls',
      'lua_ls',
      'rust_analyzer',
      'ts_ls',
      'vue_ls',
    })

    local nullls = require('null-ls')
    nullls.setup({
      timeout_ms = 5000,
      sources = {
        nullls.builtins.formatting.prettier,
        nullls.builtins.formatting.black,
        nullls.builtins.formatting.isort,
      },
    })
  end,
}
