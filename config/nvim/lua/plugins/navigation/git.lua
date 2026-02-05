-- Consolidated Git Plugin Configuration
return {
  {
    -- Git signs in gutter
    'lewis6991/gitsigns.nvim',
    opts = function()
      local icons = require('utils.icons')
      local c = {
        signs = {
          add = { text = icons.git.added },
          change = { text = icons.git.changed },
          delete = { text = icons.git.deleted },
          topdelete = { text = icons.git.deleted },
          changedelete = { text = icons.git.changed },
          untracked = { text = icons.git.added },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to next hunk' })

          map({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to previous hunk' })

          -- Actions
          map('v', '<leader>hs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'stage git hunk' })
          map('v', '<leader>hr', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'reset git hunk' })
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
          map('n', '<leader>hb', function()
            gs.blame_line { full = false }
          end, { desc = 'git blame line' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
          map('n', '<leader>hD', function()
            gs.diffthis '~'
          end, { desc = 'git diff against last commit' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
        end,
      }
      return c
    end,
    event = 'BufEnter *',
  },
  {
    -- Diff view
    'sindrets/diffview.nvim',
    lazy = true,
    enabled = true,
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
    config = function()
      local actions = require 'diffview.actions'
      require('diffview').setup {
        file_panel = {
          listing_style = 'list',
          win_config = {
            position = 'bottom',
            width = 35,
            height = 10,
          },
        },
        keymaps = {
          view = {
            { 'n', ']q', actions.select_next_entry, { desc = 'Next file' } },
            { 'n', '[q', actions.select_prev_entry, { desc = 'Previous file' } },
          },
          file_panel = {
            { 'n', ']q', actions.select_next_entry, { desc = 'Next file' } },
            { 'n', '[q', actions.select_prev_entry, { desc = 'Previous file' } },
          },
        },
      }
      -- Make diff backgrounds transparent
      vim.api.nvim_set_hl(0, 'DiffAdd', { bg = 'NONE', fg = '#a6e3a1', blend = 95 })
      vim.api.nvim_set_hl(0, 'DiffDelete', { bg = 'NONE', fg = '#f38ba8', blend = 95 })
      vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#1a2a1a', blend = 95 })
      vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#2a1a1a', blend = 95 })
    end,
  },
  {
    -- GitHub integration
    'pwntester/octo.nvim',
    cmd = 'Octo',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.g.octo_logfile = vim.fn.stdpath 'cache' .. '/octo_debug.log'
      require('octo').setup {
        default_remote = { 'upstream', 'origin' },
        enable_builtin = true,
        ssh_aliases = {},
        reaction_viewer_hint_icon = '',
        user_icon = ' ',
        timeline_marker = '',
        timeline_indent = 2,
        right_bubble_delimiter = '',
        left_bubble_delimiter = '',
        github_hostname = '',
        snippet_context_lines = 4,
        gh_env = {},
        issues = {
          order_by = {
            field = 'CREATED_AT',
            direction = 'DESC',
          },
        },
        pull_requests = {
          order_by = {
            field = 'CREATED_AT',
            direction = 'DESC',
          },
          always_select_remote_on_create = false,
        },
        file_panel = {
          size = 10,
          use_icons = true,
          use_local_fs = true,
        },
        mappings = {
          issue = {
            close_issue = { lhs = '<space>ic', desc = 'close issue' },
            reopen_issue = { lhs = '<space>io', desc = 'reopen issue' },
            list_issues = { lhs = '<space>il', desc = 'list open issues on same repo' },
            reload = { lhs = '<C-r>', desc = 'reload issue' },
            open_in_browser = { lhs = '<C-b>', desc = 'open issue in browser' },
            copy_url = { lhs = '<C-y>', desc = 'copy url to system clipboard' },
            add_assignee = { lhs = '<space>aa', desc = 'add assignee' },
            remove_assignee = { lhs = '<space>ad', desc = 'remove assignee' },
            create_label = { lhs = '<space>lc', desc = 'create label' },
            add_label = { lhs = '<space>la', desc = 'add label' },
            remove_label = { lhs = '<space>ld', desc = 'remove label' },
            goto_issue = { lhs = '<space>gi', desc = 'navigate to a local repo issue' },
            add_comment = { lhs = '<space>ca', desc = 'add comment' },
            delete_comment = { lhs = '<space>cd', desc = 'delete comment' },
            next_comment = { lhs = ']c', desc = 'go to next comment' },
            prev_comment = { lhs = '[c', desc = 'go to previous comment' },
            react_hooray = { lhs = '<space>rp', desc = 'add/remove 🎉 reaction' },
            react_heart = { lhs = '<space>rh', desc = 'add/remove ❤️ reaction' },
            react_eyes = { lhs = '<space>re', desc = 'add/remove 👀 reaction' },
            react_thumbs_up = { lhs = '<space>r+', desc = 'add/remove 👍 reaction' },
            react_thumbs_down = { lhs = '<space>r-', desc = 'add/remove 👎 reaction' },
            react_rocket = { lhs = '<space>rr', desc = 'add/remove 🚀 reaction' },
            react_laugh = { lhs = '<space>rl', desc = 'add/remove 😄 reaction' },
            react_confused = { lhs = '<space>rc', desc = 'add/remove 😕 reaction' },
          },
          pull_request = {
            checkout_pr = { lhs = '<space>po', desc = 'checkout PR' },
            merge_pr = { lhs = '<space>pm', desc = 'merge commit PR' },
            squash_and_merge_pr = { lhs = '<space>psm', desc = 'squash and merge PR' },
            list_commits = { lhs = '<space>pc', desc = 'list PR commits' },
            list_changed_files = { lhs = '<space>pf', desc = 'list PR changed files' },
            show_pr_diff = { lhs = '<space>pd', desc = 'show PR diff' },
            add_reviewer = { lhs = '<space>va', desc = 'add reviewer' },
            remove_reviewer = { lhs = '<space>vd', desc = 'remove reviewer request' },
            close_issue = { lhs = '<space>ic', desc = 'close PR' },
            reopen_issue = { lhs = '<space>io', desc = 'reopen PR' },
            list_issues = { lhs = '<space>il', desc = 'list open issues on same repo' },
            reload = { lhs = '<C-r>', desc = 'reload PR' },
            open_in_browser = { lhs = '<C-b>', desc = 'open PR in browser' },
            copy_url = { lhs = '<C-y>', desc = 'copy url to system clipboard' },
            goto_file = { lhs = 'gf', desc = 'go to file' },
            add_assignee = { lhs = '<space>aa', desc = 'add assignee' },
            remove_assignee = { lhs = '<space>ad', desc = 'remove assignee' },
            create_label = { lhs = '<space>lc', desc = 'create label' },
            add_label = { lhs = '<space>la', desc = 'add label' },
            remove_label = { lhs = '<space>ld', desc = 'remove label' },
            goto_issue = { lhs = '<space>gi', desc = 'navigate to a local repo issue' },
            add_comment = { lhs = '<space>ca', desc = 'add comment' },
            delete_comment = { lhs = '<space>cd', desc = 'delete comment' },
            next_comment = { lhs = ']c', desc = 'go to next comment' },
            prev_comment = { lhs = '[c', desc = 'go to previous comment' },
            react_hooray = { lhs = '<space>rp', desc = 'add/remove 🎉 reaction' },
            react_heart = { lhs = '<space>rh', desc = 'add/remove ❤️ reaction' },
            react_eyes = { lhs = '<space>re', desc = 'add/remove 👀 reaction' },
            react_thumbs_up = { lhs = '<space>r+', desc = 'add/remove 👍 reaction' },
            react_thumbs_down = { lhs = '<space>r-', desc = 'add/remove 👎 reaction' },
            react_rocket = { lhs = '<space>rr', desc = 'add/remove 🚀 reaction' },
            react_laugh = { lhs = '<space>rl', desc = 'add/remove 😄 reaction' },
            react_confused = { lhs = '<space>rc', desc = 'add/remove 😕 reaction' },
          },
          review_thread = {
            goto_issue = { lhs = '<space>gi', desc = 'navigate to a local repo issue' },
            add_comment = { lhs = '<space>ca', desc = 'add comment' },
            add_suggestion = { lhs = '<space>sa', desc = 'add suggestion' },
            delete_comment = { lhs = '<space>cd', desc = 'delete comment' },
            next_comment = { lhs = ']c', desc = 'go to next comment' },
            prev_comment = { lhs = '[c', desc = 'go to previous comment' },
            select_next_entry = { lhs = ']q', desc = 'move to previous changed file' },
            select_prev_entry = { lhs = '[q', desc = 'move to next changed file' },
            close_review_tab = { lhs = '<C-c>', desc = 'close review tab' },
            react_hooray = { lhs = '<space>rp', desc = 'add/remove 🎉 reaction' },
            react_heart = { lhs = '<space>rh', desc = 'add/remove ❤️ reaction' },
            react_eyes = { lhs = '<space>re', desc = 'add/remove 👀 reaction' },
            react_thumbs_up = { lhs = '<space>r+', desc = 'add/remove 👍 reaction' },
            react_thumbs_down = { lhs = '<space>r-', desc = 'add/remove 👎 reaction' },
            react_rocket = { lhs = '<space>rr', desc = 'add/remove 🚀 reaction' },
            react_laugh = { lhs = '<space>rl', desc = 'add/remove 😄 reaction' },
            react_confused = { lhs = '<space>rc', desc = 'add/remove 😕 reaction' },
          },
          submit_win = {
            approve_review = { lhs = '<C-a>', desc = 'approve review' },
            comment_review = { lhs = '<C-m>', desc = 'comment review' },
            request_changes = { lhs = '<C-r>', desc = 'request changes review' },
            close_review_tab = { lhs = '<C-c>', desc = 'close review tab' },
          },
          review_diff = {
            add_review_comment = { lhs = '<space>ca', desc = 'add a new review comment' },
            add_review_suggestion = { lhs = '<space>sa', desc = 'add a new review suggestion' },
            focus_files = { lhs = '<leader>e', desc = 'move focus to changed file panel' },
            toggle_files = { lhs = '<leader>b', desc = 'hide/show changed files panel' },
            next_thread = { lhs = ']t', desc = 'move to next thread' },
            prev_thread = { lhs = '[t', desc = 'move to previous thread' },
            select_next_entry = { lhs = ']q', desc = 'move to previous changed file' },
            select_prev_entry = { lhs = '[q', desc = 'move to next changed file' },
            close_review_tab = { lhs = '<C-c>', desc = 'close review tab' },
            toggle_viewed = { lhs = '<leader><space>', desc = 'toggle viewer viewed state' },
          },
          file_panel = {
            next_entry = { lhs = 'j', desc = 'move to next changed file' },
            prev_entry = { lhs = 'k', desc = 'move to previous changed file' },
            select_entry = { lhs = '<cr>', desc = 'show selected changed file diffs' },
            refresh_files = { lhs = 'R', desc = 'refresh changed files panel' },
            focus_files = { lhs = '<leader>e', desc = 'move focus to changed file panel' },
            toggle_files = { lhs = '<leader>b', desc = 'hide/show changed files panel' },
            select_next_entry = { lhs = ']q', desc = 'move to previous changed file' },
            select_prev_entry = { lhs = '[q', desc = 'move to next changed file' },
            close_review_tab = { lhs = '<C-c>', desc = 'close review tab' },
            toggle_viewed = { lhs = '<leader><space>', desc = 'toggle viewer viewed state' },
          },
        },
      }
      vim.cmd [[hi OctoEditable guibg=none]]
    end,
    keys = function()
      local wk = require 'which-key'
      wk.add { '<leader>o', group = 'Octo' }
      wk.add { '<leader>oi', group = 'issue' }
      wk.add { '<leader>op', group = 'pr' }
      wk.add { '<leader>or', group = 'review' }

      return {
        { '<leader>oo', '<cmd>Octo<cr>', desc = 'Octo' },
        { '<leader>oi/', '<cmd>Octo issue search<cr>', desc = 'Search issues' },
        { '<leader>oii', '<cmd>Octo issue create<cr>', desc = 'Create issue' },
        { '<leader>oil', '<cmd>Octo issue list<cr>', desc = 'List issues' },
        { '<leader>oio', '<cmd>Octo issue browser<cr>', desc = 'Open issue in browser' },
        { '<leader>oiy', '<cmd>Octo issue url<cr>', desc = 'Copy issue URL' },
        { '<leader>oP', '<cmd>Octo !pbpaste<cr>', desc = 'Octo (pbpaste)' },
        { '<leader>op/', '<cmd>Octo pr search<cr>', desc = 'Search prs' },
        { '<leader>opi', '<cmd>Octo pr create<cr>', desc = 'Create pr' },
        { '<leader>opl', '<cmd>Octo pr list<cr>', desc = 'List prs' },
        { '<leader>opo', '<cmd>Octo pr browser<cr>', desc = 'Open pr in browser' },
        { '<leader>opy', '<cmd>Octo pr url<cr>', desc = 'Copy pr URL' },
        { '<leader>opc', '<cmd>Octo pr commits<cr>', desc = 'PR commits' },
        { '<leader>opd', '<cmd>Octo pr diff<cr>', desc = 'PR diff' },
        { '<leader>orC', '<cmd>Octo review comments<cr>', desc = 'Pick commit' },
        { '<leader>orc', '<cmd>Octo review commit<cr>', desc = 'View comments' },
        { '<leader>orD', '<cmd>Octo review discard<cr>', desc = 'Discard pending review' },
        { '<leader>orr', '<cmd>Octo review resume<cr>', desc = 'Resume review' },
        { '<leader>ors', '<cmd>Octo review start<cr>', desc = 'Start review' },
        { '<leader>orS', '<cmd>Octo review submit<cr>', desc = 'Submit review' },
        { '<leader>orX', '<cmd>Octo review close<cr>', desc = 'Close review' },
      }
    end,
  },
  {
    -- Git blame
    'FabijanZulj/blame.nvim',
    lazy = true,
    cmd = { 'BlameToggle' },
    config = function()
      require('blame').setup()
    end,
  },
}
