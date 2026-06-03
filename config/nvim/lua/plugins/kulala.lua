return {
  'mistweaverco/kulala.nvim',
  keys = {
    {
      '<leader>rr',
      function()
        require('kulala').run()
      end,
      desc = 'Send request',
    },
    {
      '<leader>Ra',
      function()
        require('kulala').run_all()
      end,
      desc = 'Send all requests',
    },
    {
      '<leader>Rb',
      function()
        require('kulala').scratchpad()
      end,
      desc = 'Open scratchpad',
    },
    {
      '<leader>re',
      function()
        require('kulala').set_selected_env()
      end,
      desc = 'Select environment',
    },
    {
      '<leader>ri',
      function()
        require('kulala').inspect()
      end,
      desc = 'Inspect current request',
    },
    {
      '<leader>rt',
      function()
        require('kulala').toggle_view()
      end,
      desc = 'Toggle headers/body view',
    },
  },
  ft = { 'http', 'rest' },
  opts = {
    formatters = {
      json = { 'jq', '.' },
    },
    default_env = 'dev',
    ui = {
      max_response_size = 1048576, -- 1 MB (or any size you want in bytes)
    },
    global_keymaps = false,
    global_keymaps_prefix = '<leader>R',
    kulala_keymaps_prefix = '',
    kulala_keymaps = {
      ['Show verbose'] = {
        'gv',
        function()
          require('kulala.ui').show_verbose()
        end,
      },
    },
  },
}
