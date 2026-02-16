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
  },
  ft = { 'http', 'rest' },
  opts = {
    formatters = {
      json = { 'jq', '.' },
    },

    ui = {
      max_response_size = 1048576, -- 1 MB (or any size you want in bytes)
    },
    global_keymaps = false,
    global_keymaps_prefix = '<leader>R',
    kulala_keymaps_prefix = '',
  },
}
