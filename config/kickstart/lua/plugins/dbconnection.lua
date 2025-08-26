return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    config = function()
      -- Helper function to fetch passwords from pass
      local function pass(entry)
        local handle = io.popen('pass show ' .. entry)
        if handle then
          local result = handle:read '*l' -- read first line (password)
          handle:close()
          return result or ''
        end
        return ''
      end

      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.dbs = {
        {
          name = 'ctl_local',
          url = string.format('postgresql://myuser:%s@localhost:1432/warehouse', pass 'ctl/local'),
        },
        {
          name = 'ctl_dev',
          url = string.format('postgresql://garrett.krohn:%s@localhost:1111/warehouse', pass 'ctl/dev'),
        },
        {
          name = 'platform_local',
          url = string.format('postgresql://postgres:%s@localhost:4432/novaapi', pass 'platform/local'),
        },
        {
          name = 'platform_dev',
          url = string.format('postgresql://gkrohn:%s@localhost:1112/novaapi', pass 'platform/dev'),
        },
        {
          name = 'platform_prod',
          url = string.format('postgresql://gkrohn:%s@localhost:1113/novaapi', pass 'platform/prod'),
        },
      }
    end,
  },
  {
    -- optional completion integration
    'saghen/blink.cmp',
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
        },
        providers = {
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
  },
}
