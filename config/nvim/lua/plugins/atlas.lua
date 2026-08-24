return {
  'emrearmagan/atlas.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'MeanderingProgrammer/render-markdown.nvim',
    'esmuellert/codediff.nvim',
    'sindrets/diffview.nvim',
  },
  opts = {
    global_statusline = true,

    pulls = {
      diff = {
        open_cmd = 'AtlasDiff',
        layout = 'inline',
        compact = true,
        compact_context_lines = 3,
        show_review_panel = false,
        explorer = { grouped = true, hidden = false, width = 40 },
      },
      providers = {
        github = {
          cache_ttl = 300,
          views = {
            { name = 'My PRs', key = '1', layout = 'plain', search = 'author:@me sort:updated-desc' },
            { name = 'Review Requested', key = '2', layout = 'plain', search = 'review-requested:@me is:open' },
            { name = 'Drafts', key = '3', layout = 'plain', search = 'author:@me is:draft' },
          },
          bookmarks = {
            key = 'S',
            label = 'Search',
            items = {
              ['All Open'] = 'is:pr is:open',
            },
          },
        },
        bitbucket = {
          user = vim.env.BITBUCKET_USER,
          token = vim.env.BITBUCKET_TOKEN,
          cache_ttl = 300,
          views = {
            { name = 'My PRs', key = '1', layout = 'plain' },
          },
        },
      },
    },

    issues = {
      max_results = 100,
      with_relationships = true,
      providers = {
        github = {
          cache_ttl = 300,
          views = {
            { name = 'Assigned', key = '1', layout = 'plain', search = 'assignee:@me is:open' },
            { name = 'Created', key = '2', layout = 'plain', search = 'author:@me is:open' },
          },
          bookmarks = {
            key = 'S',
            label = 'Search',
            items = {
              ['Bugs'] = 'is:issue is:open label:bug',
            },
          },
        },
        jira = {
          base_url = vim.env.JIRA_BASE_URL,
          email = vim.env.JIRA_EMAIL,
          token = vim.env.JIRA_TOKEN,
          auth_method = 'basic',
          api_type = 'cloud',
          cache_ttl = 300,
          views = {
            { name = 'My Issues', key = '1', layout = 'plain', jql = 'assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC' },
            { name = 'In Progress', key = '2', layout = 'plain', jql = 'assignee = currentUser() AND status = "In Progress"' },
          },
          bookmarks = {
            key = 'J',
            label = 'JQL',
            items = {
              ['Backlog'] = 'assignee = currentUser() AND statusCategory = "To Do"',
            },
          },
        },
      },
    },
  },
  keys = function()
    local wk = require 'which-key'
    wk.add { '<leader>a', group = 'Atlas' }
    wk.add { '<leader>ai', group = 'issues' }
    wk.add { '<leader>ap', group = 'pulls' }

    return {
      { '<leader>ap', '<cmd>AtlasPulls<cr>', desc = 'Pull Requests' },
      { '<leader>apg', '<cmd>AtlasPulls github<cr>', desc = 'GitHub PRs' },
      { '<leader>apb', '<cmd>AtlasPulls bitbucket<cr>', desc = 'Bitbucket PRs' },
      { '<leader>ai', '<cmd>AtlasIssues<cr>', desc = 'Issues' },
      { '<leader>aig', '<cmd>AtlasIssues github<cr>', desc = 'GitHub Issues' },
      { '<leader>aij', '<cmd>AtlasIssues jira<cr>', desc = 'Jira Issues' },
      { '<leader>as', '<cmd>AtlasSearch<cr>', desc = 'Search' },
      { '<leader>an', '<cmd>AtlasNotes<cr>', desc = 'Review Notes' },
      { '<leader>aP', '<cmd>AtlasCreatePR<cr>', desc = 'Create PR' },
      { '<leader>aI', '<cmd>AtlasCreateIssue<cr>', desc = 'Create Issue' },
      { '<leader>ax', '<cmd>AtlasClearCache<cr>', desc = 'Clear Cache' },
      { '<leader>al', '<cmd>AtlasLogs<cr>', desc = 'Logs' },
    }
  end,
}
