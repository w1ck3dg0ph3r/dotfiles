local on_attach

local plugin = {
  'nvim-tree/nvim-tree.lua',

  enabled = false,

  dependencies = { 'nvim-tree/nvim-web-devicons' },

  keys = { '<leader>e' },

  opts = {
    on_attach = on_attach,
    sort_by = 'case_sensitive',
    view = {
      width = 40,
    },
    update_focused_file = {
      enable = true,
    },
    renderer = {
      root_folder_label = ':t',
      icons = {
        glyphs = {
          git = {
            unstaged = '󱗜',
            staged = '',
            unmerged = '',
            renamed = '➜',
            untracked = '󰩳',
            deleted = '',
            ignored = '◌',
          }
        }
      }
    },
    filters = { custom = { '^\\.git$' } },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = '',
        info = '',
        warning = '󰀪',
        error = '',
      },
    },

  },

  config = function(_, opts)
    require('nvim-tree').setup(opts)

    require('util').map('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

    local api = require('nvim-tree.api')

    -- Go to last used hidden buffer when deleting a buffer
    vim.api.nvim_create_autocmd('BufEnter', {
      nested = true,
      callback = function()
        -- Only 1 window with nvim-tree left: we probably closed a file buffer
        if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
          -- Required to let the close event complete. An error is thrown without this.
          vim.defer_fn(function()
            -- close nvim-tree: will go to the last hidden buffer used before closing
            api.tree.toggle({ find_file = true, focus = true })
            -- re-open nivm-tree
            api.tree.toggle({ find_file = true, focus = true })
            -- nvim-tree is still the active window. Go to the previous window.
            vim.cmd('wincmd p')
          end, 0)
        end
      end
    })
  end,
}

on_attach = function(bufnr)
  local api = require('nvim-tree.api')
  local util = require('util')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- BEGIN_DEFAULT_ON_ATTACH
  util.map('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  util.map('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
  util.map('n', '<C-k>', api.node.show_info_popup, opts('Info'))
  util.map('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
  util.map('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  util.map('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  util.map('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  util.map('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  util.map('n', '<CR>', api.node.open.edit, opts('Open'))
  util.map('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
  util.map('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
  util.map('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
  util.map('n', '.', api.node.run.cmd, opts('Run Command'))
  util.map('n', '-', api.tree.change_root_to_parent, opts('Up'))
  util.map('n', 'a', api.fs.create, opts('Create'))
  util.map('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
  util.map('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
  util.map('n', 'c', api.fs.copy.node, opts('Copy'))
  util.map('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
  util.map('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
  util.map('n', ']c', api.node.navigate.git.next, opts('Next Git'))
  util.map('n', 'd', api.fs.remove, opts('Delete'))
  util.map('n', 'D', api.fs.trash, opts('Trash'))
  util.map('n', 'E', api.tree.expand_all, opts('Expand All'))
  util.map('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
  util.map('n', ']d', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  util.map('n', '[d', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  util.map('n', 'F', api.live_filter.clear, opts('Clean Filter'))
  util.map('n', 'f', api.live_filter.start, opts('Filter'))
  util.map('n', 'g?', api.tree.toggle_help, opts('Help'))
  util.map('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  util.map('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  util.map('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
  util.map('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
  util.map('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
  util.map('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
  util.map('n', 'o', api.node.open.edit, opts('Open'))
  util.map('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
  util.map('n', 'p', api.fs.paste, opts('Paste'))
  util.map('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
  util.map('n', 'q', api.tree.close, opts('Close'))
  util.map('n', 'r', api.fs.rename, opts('Rename'))
  util.map('n', 'R', api.tree.reload, opts('Refresh'))
  util.map('n', 's', api.node.run.system, opts('Run System'))
  util.map('n', 'S', api.tree.search_node, opts('Search'))
  util.map('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
  util.map('n', 'W', api.tree.collapse_all, opts('Collapse'))
  util.map('n', 'x', api.fs.cut, opts('Cut'))
  util.map('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  util.map('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  util.map('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  util.map('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH

  util.map('n', '<space>', api.node.open.edit, opts('Open'))
end

return plugin
