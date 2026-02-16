return {
  {
    enabled = false,
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
      -- helper to run `pass` at startup
      local function pass(entry)
        return vim.fn.system('pass ' .. entry):gsub('\n', '')
      end

      vim.g.dbs = {
        {
          name = 'platform_local',
          url = string.format('postgresql://postgres:%s@localhost:4432/novaapi', 'postgres'),
        },
        {
          name = 'platform_dev',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/novaapi', pass 'dev01'),
        },
        {
          name = 'platform_dev_workflow',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/workflow_engine', pass 'dev01'),
        },
        {
          name = 'platform_ptx',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/novaapi', pass 'ptx01'),
        },
        {
          name = 'platform_prod',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/novaapi', pass 'prod01'),
        },
        {
          name = 'platform_prod_workflow_engine',
          url = string.format('postgresql://gkrohn:%s@localhost:1111/workflow_engine', pass 'prod01'),
        },
        {
          name = 'ctl_local',
          url = string.format('postgresql://myuser:%s@localhost:1432/warehouse', pass 'ctl/local'),
        },
        {
          name = 'ctl_dev',
          url = string.format('postgresql://garrett.krohn:%s@localhost:1111/warehouse', pass 'dw01'),
        },
      }
    end,
  },
  -- {
  --   -- optional completion integration
  --   'saghen/blink.cmp',
  --   opts = {
  --     sources = {
  --       default = { 'lsp', 'path', 'snippets', 'buffer' },
  --       per_filetype = {
  --         sql = { 'snippets', 'dadbod', 'buffer' },
  --       },
  --       providers = {
  --         dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
  --       },
  --     },
  --   },
  -- },
}
