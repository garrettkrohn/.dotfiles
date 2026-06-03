return {
  'christoomey/vim-tmux-navigator', -- tmux & split window navigation
  event = 'BufEnter *',
  config = function()
    -- Set up terminal mode keybindings for Claude Code terminal buffers
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function(args)
        local bufnr = args.buf
        -- Add terminal mode keybindings for vim-tmux-navigator
        vim.keymap.set('t', '<C-h>', '<cmd>TmuxNavigateLeft<cr>', { buffer = bufnr, silent = true })
        vim.keymap.set('t', '<C-j>', '<cmd>TmuxNavigateDown<cr>', { buffer = bufnr, silent = true })
        vim.keymap.set('t', '<C-k>', '<cmd>TmuxNavigateUp<cr>', { buffer = bufnr, silent = true })
        vim.keymap.set('t', '<C-l>', '<cmd>TmuxNavigateRight<cr>', { buffer = bufnr, silent = true })
      end,
    })
  end,
}
