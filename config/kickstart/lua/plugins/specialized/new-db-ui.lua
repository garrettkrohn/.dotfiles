return {
  dir = '/Users/gkrohn/code/neovim_plugins/dadview.nvim',
  lazy = false,
  name = 'dadview',
  dependencies = {
    'tpope/vim-dadbod',
  },
  config = function()
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

    require('dadview').setup {
      width = 40,
      position = 'left',
      auto_open_query_buffer = true,
    }
  end,
}
