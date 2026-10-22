return {
  'goolord/alpha-nvim',
  branch = 'main',

  event = 'VimEnter',

  config = function()
    local alpha = require('alpha')

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
      },
      opts = {
        position = 'center',
        hl = 'Function',
      },
    }

    local button = require('alpha.themes.dashboard').button

    local buttons = {
      type = 'group',
      val = {
        button('e', '  New file', '<cmd>enew<cr>'),
        button('f', '󰈞  Find file', '<leader>sf', { remap = true }),
        button('g', '  Grep files', '<leader>sg', { remap = true }),
        button('h', '󰋗  Search help', '<leader>sh', { remap = true }),
        button('c', '  Search commands', '<leader>sc', { remap = true }),
        button('q', '󰗼  Exit neovim', '<cmd>q<cr>'),
      },
      opts = {
        spacing = 1,
      },
    }

    local config = {
      layout = { {
        type = 'group',
        val = {
          header,
          { type = 'padding', val = 2 },
          buttons,
        },
        opts = {
          position = 'v_center',
        },
      } },
    }

    alpha.setup(config)
  end,
}
