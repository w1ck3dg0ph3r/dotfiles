return {
  'goolord/alpha-nvim',
  branch = 'main',

  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  event = 'VimEnter',

  config = function()
    local alpha = require('alpha')

    local terminal = {
      type = 'terminal',
      command = nil,
      width = 69,
      height = 8,
      opts = {
        redraw = true,
        window_config = {},
      },
    }

    local header = {
      type = 'text',
      val = {
        [[                                                     ]],
        [[  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ ]],
        [[  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ]],
        [[ ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ ]],
        [[ ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  ]],
        [[ ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ ]],
        [[ ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ ]],
        [[ ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ ]],
        [[    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    ]],
        [[          ░    ░  ░    ░ ░        ░   ░         ░    ]],
        [[                                 ░                   ]],
        [[                                                     ]],
        -- [[                                                                       ]],
        -- [[  ██████   █████                   █████   █████  ███                  ]],
        -- [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
        -- [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
        -- [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
        -- [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
        -- [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
        -- [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
        -- [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
        -- [[                                                                       ]],
      },
      opts = {
        position = 'center',
        hl = 'Function',
      },
    }

    local footer = {
      type = 'text',
      val = '',
      opts = {
        position = 'center',
        hl = 'Number',
      },
    }

    --- @param sc string
    --- @param txt string
    --- @param keybind string? optional
    --- @param keybind_opts table? optional
    local function button(sc, txt, keybind, keybind_opts)
      local sc_ = sc:gsub('%s', '')
      local opts = {
        position = 'center',
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = 'right',
        hl_shortcut = 'Keyword',
      }
      if keybind then
        if keybind_opts == nil then
          keybind_opts = { noremap = true, silent = true, nowait = true }
        end
        opts.keymap = { 'n', sc_, keybind, keybind_opts }
      end

      local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. '<Ignore>', true, false, true)
        vim.api.nvim_feedkeys(key, 't', false)
      end

      return {
        type = 'button',
        val = txt,
        on_press = on_press,
        opts = opts,
      }
    end

    local buttons = {
      type = 'group',
      val = {
        button('e', '  New file', '<cmd>enew<cr>'),
        button('f', '󰈞  Find file', '<leader>sf', { remap = true }),
        button('g', '  Grep files', '<leader>sg', { remap = true }),
        button('h', '󰞋  Search help', '<leader>sh', { remap = true }),
        button('q', '󰗼  Exit neovim', '<cmd>q<cr>'),
      },
      opts = {
        spacing = 1,
      },
    }

    local section = {
      terminal = terminal,
      header = header,
      buttons = buttons,
      footer = footer,
    }

    local config = {
      layout = {
        { type = 'padding', val = 4 },
        section.header,
        { type = 'padding', val = 4 },
        section.buttons,
        section.footer,
      },
      opts = {
        margin = 5,
      },
    }

    alpha.setup(config)
  end,
}
