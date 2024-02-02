return {
  'hrsh7th/nvim-cmp',

  event = 'InsertEnter',

  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  },

  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local kind_icons = {
      Text = '',
      Method = '󰆧',
      Function = '󰊕',
      Constructor = '',
      Field = '󰇽',
      Variable = '󰂡',
      Class = '󰠱',
      Interface = '',
      Module = '',
      Property = '󰜢',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰏿',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰅲',
    }

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ['<c-j>'] = cmp.mapping.select_next_item(),
        ['<c-k>'] = cmp.mapping.select_prev_item(),
        ['<c-b>'] = cmp.mapping.scroll_docs(-4),
        ['<c-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<c-e>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm({ select = true }),

        ['<tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<s-tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          vim_item.menu = ({
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
        expandable_indicator = true,
      },

      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 15 },
        { name = 'luasnip',  priority = 10 },
        { name = 'path',     priority = 5 },
        { name = 'buffer',   priority = 1 },
      }),

      ---@diagnostic disable-next-line: missing-fields
      sorting = {
        priority_weight = 2.5,
        comparators = {
          cmp.config.compare.offset,    -- Entries with smaller offset will be ranked higher.
          cmp.config.compare.exact,     -- Entries with exact == true will be ranked higher.
          cmp.config.compare.score,     -- Entries with higher score will be ranked higher.
          -- cmp.config.compare.length,    -- Entires with shorter label length will be ranked higher.
          cmp.config.compare.sort_text, -- Entries will be ranked according to the lexicographical order of sortText.
          cmp.config.compare.order,     -- Entries with smaller id will be ranked higher.
          cmp.config.compare.kind,      -- Entires with smaller ordinal value of 'kind' will be ranked higher.
          -- cmp.config.compare.locality,      -- Entries with higher locality (i.e., words that are closer to the cursor) will be ranked higher. See GH-183 for more details.
          -- cmp.config.compare.recently_used, -- Entries that are used recently will be ranked higher.
          -- cmp.config.compare.scopes,        -- Entries defined in a closer scope will be ranked higher (e.g., prefer local variables to globals).
        }
      },

      preselect = cmp.PreselectMode.None,
    })

    require('luasnip.loaders.from_vscode').lazy_load()
  end,
}
