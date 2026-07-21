return {
  -- 'garrettkrohn/dadview.nvim',
  dir = '/Users/gkrohn/code/neovim_plugins/dadview.nvim',
  cmd = {
    'DadView',
    'DadViewToggle',
    'DadViewConnect',
    'DadViewClose',
    'DadViewNewQuery',
    'DadViewExecute',
    'DadViewCancel',
    'DadViewFindBuffer',
    'DadViewRenameBuffer',
    'DadViewLastQueryInfo',
    'DB',
    'DBCancel',
  },
  config = function()
    local function pass(entry)
      return vim.fn.system('pass ' .. entry):gsub('\n', '')
    end

    local ok, secret_dbs = pcall(require, 'plugins.secrets.dadview')
    vim.g.dbs = ok and secret_dbs or {}

    require('dadview').setup {
      width = 40,
      position = 'left',
      auto_open_query_buffer = true,
      result_split = 'vertical',
    }
  end,
}
