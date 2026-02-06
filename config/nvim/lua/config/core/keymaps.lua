-- set leader key to space
vim.g.mapleader = ' '

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- clear search highlights
keymap.set('n', '<leader>n', ':nohl<CR>', { desc = 'clear search highlights' })

-- source current file
keymap.set('n', '<leader>x', ':source %<cr>', { desc = 'source current file' })

-- delete single character without copying into register
keymap.set('n', 'x', '"_x', { desc = 'delete char withotu copying' })

-- increment/decrement numbers
-- keymap.set('n', '<leader>+', '<C-a>') -- increment
-- keymap.set('n', '<leader>-', '<C-x>') -- decrement

-- window management
keymap.set('n', 'sv', '<C-w>v', { desc = 'split window vertically' })
keymap.set('n', 'sh', '<C-w>s', { desc = 'split window horizontally' })
keymap.set('n', 'se', '<C-w>=', { desc = 'make split windows equal width and height' })
keymap.set('n', 'sx', ':close<CR>', { desc = 'close current split window' })

-- keymap.set('n', '<leader>to', ':tabnew<CR>') -- open new tab
-- keymap.set('n', '<leader>tx', ':tabclose<CR>') -- close current tab
-- keymap.set('n', '<leader>tn', ':tabn<CR>') --  go to next tab
-- keymap.set('n', '<leader>tp', ':tabp<CR>') --  go to previous tab
-- keymap.set('n', 'sg', ':lua require("telescope.builtin").lsp_definitions()<CR>|<C-w>v')

-- bufferline clear all buffers except this one
keymap.set('n', '<leader>xx', ':%bd|e#<CR>', { desc = 'clear all buffers except curent one' })
----------------------
-- Plugin Keybinds
----------------------

keymap.set('n', '<leader><leader>', ':Oil<CR>', { desc = 'Toggle oil' }) -- toggle file explorer

-- telescope
-- keymap.set('n', '<leader>ff', '<cmd>Telescope frecency workspace=CWD path_display={"shorten"}<cr>') -- find files within current working directory, respects .gitignore
-- keymap.set('n', '<leader>/', '<cmd>Telescope live_grep<cr>') -- find string in current working directory as you type
-- keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>') -- find string under cursor in current working directory
-- keymap.set('n', '<leader>fb', '<cmd>Telescope buffers formatter=path.filename_first<cr>') -- list open buffers in current neovim instance
-- keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>') -- list available help tags
-- TODO: not a huge fan of this
-- keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', { desc = 'goto definition' }) -- list available help tags
-- keymap.set('n', '<leader>gf', ':Telescope lsp_references show_line=false<CR>')

-- fzf commands
-- keymap.set('n', 'ff', '<cmd>FzfLua files formatter=path.filename_first<cr>') -- find files within current working directory, respects .gitignore
-- keymap.set('n', 'fs', '<cmd>FzfLua live_grep<cr>') -- find string in current working directory as you type
-- keymap.set('n', 'fc', '<cmd>FzfLua grep_string<cr>') -- find string under cursor in current working directory
-- keymap.set('n', 'fb', '<cmd>FzfLua buffers formatter=path.filename_first<cr>') -- list open buffers in current neovim instance
-- keymap.set('n', 'fh', '<cmd>FzfLua help_tags<cr>') -- list available help tags
-- keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<cr>') -- list available help tags
-- keymap.set('n', 'gd', function()
--   vim.cmd 'FzfLua lsp_definitions'
--   vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true))
-- end)

-- telescope git commands (not on youtube nvim video)
-- keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
-- keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
-- keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
-- keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video)
keymap.set('n', '<leader>rs', ':LspRestart<CR>', { desc = 'restart lsp server' }) -- mapping to restart lsp if necessary

-- save and quit
-- moved save to a user function to check filetype
-- keymap.set('n', '<leader>ss', ':w!<CR>')
keymap.set('n', '<leader>sf', ':noa w!<CR>')
-- keymap.set('n', '<leader>sa', ':wa!<CR>')
keymap.set('n', '<leader>sfa', ':noa wa!<CR>')
keymap.set('n', 'q', ':q<CR>')
keymap.set('n', 'Q', ':q!<CR>')

-- move the macro to m
vim.api.nvim_set_keymap('n', 'm', 'q', { desc = 'Macro', noremap = true })

-- bufferline tab close
-- keymap.set('n', '<leader>tx', ':bdelete!<CR>')

-- lazygit keybind
-- keymap.set('n', '<leader>gg', ':LazyGit<CR>')

keymap.set('n', 'ca', "<cmd>lua require('fastaction').code_action()<CR>", { desc = 'code actions (fastaction)' }) -- see available code actions
-- keymap.set('n', '<leader>gt', '<cmd>Lspsaga peek_type_definition<CR>')

-- keymap.set('n', '<leader>po', "<cmd>lua require('rest-nvim').run()<CR>") -- see available code actions

-- harpoon
-- local harpoon = require 'harpoon'
-- keymap.set('n', '<leader>ha', function()
--     harpoon:list():add()
-- end)
-- keymap.set('n', '<leader>hh', function()
--     harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)

-- vim.keymap.set('n', '<leader>j', function()
--     harpoon:list():select(1)
-- end)
-- vim.keymap.set('n', '<leader>k', function()
--     harpoon:list():select(2)
-- end)
-- vim.keymap.set('n', '<leader>l', function()
--     harpoon:list():select(3)
-- end)
-- vim.keymap.set('n', '<leader>;', function()
--     harpoon:list():select(4)
-- end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- lsp
-- TODO: add a copy contents
keymap.set('n', '<leader>ge', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'show diagnostics for a line' }) -- show  diagnostics for line

-- gitsigns
keymap.set('n', 'gj', '<cmd>Gitsigns next_hunk<CR>', { desc = 'go to next hunk' })
keymap.set('n', 'gk', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'go to previous hunk' })

-- scissors
-- vim.keymap.set('n', '<leader>se', function()
--     require('scissors').editSnippet()
-- end)

-- When used in visual mode prefills the selection as body.
-- vim.keymap.set({ 'n', 'x' }, '<leader>sn', function()
--     require('scissors').addNewSnippet()
-- end)

-- toggle wrap
keymap.set('n', '<leader>w', ':set wrap!<CR>', { desc = 'Toggle wrap' })

-- toggle blame
keymap.set('n', '<leader>tb', ':BlameToggle<CR>', { desc = 'Toggle blame' })

-- insert date
-- TODO: format this for blog posts?
keymap.set('n', '<leader>id', ":pu=strftime('%m/%d/%y')<CR>", { desc = 'insert date' })

-- lsp
-- keymap.set("n", "<leader>li", ":LspInfo<CR>") -- show  diagnostics for line
-- keymap.set("n", "<leader>lr", ":LspRestart<CR>") -- show  diagnostics for line

-- testing
keymap.set('n', '<leader>tw', "<cmd>lua require('neotest').run.run({ jestCommand = 'yarn test-watch' })<cr>", { desc = 'Neotest Watch' })
keymap.set('n', '<leader>tf', ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = 'Neotest run file' }) -- run tests for file
keymap.set('n', '<leader>tt', ":lua require('neotest').run.run()<CR>", { desc = 'Neotest run test' }) -- run tests for file
keymap.set('n', '<leader>ts', ":lua require('neotest').summary.toggle()<CR>", { desc = 'Neotest toggle summary' }) -- run tests for file

-- Type peaking
-- TODO: I would like to do this with a border
keymap.set('n', '<leader>ty', ':lua vim.lsp.buf.hover()<CR>', { desc = 'Peak at type' }) -- peak at type

-- quickfix errors
keymap.set('n', '<leader>fe', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- TODO: set a different keymap for this
-- keymap.set('n', '<leader>eq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- filepath
keymap.set('n', '<leader>p', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  print(filepath)
  vim.fn.setreg('+', filepath)
end, { desc = 'print and copy file path' })

-- auth
-- keymap.set('n', '<leader>au', ':terminal ~/code/rest/auth.sh<CR>', { desc = 'Platform auth for rest' })

-- diagnostics
keymap.set('n', '<leader>tc', ':lua vim.diagnostic.hide()<CR>', { desc = 'Hide diagnostics' })
keymap.set('n', '<leader>to', ':lua vim.diagnostic.show()<CR>', { desc = 'Show diagnostics' })
-- suppress all vim diagnostics besides ERROR
keymap.set(
  'n',
  '<leader>v',
  ':lua vim.diagnostic.config({ virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } }, signs = { severity = { min = vim.diagnostic.severity.ERROR } }, underline = { severity = { min = vim.diagnostic.severity.ERROR } }, update_in_insert = false })<CR>',
  { desc = 'Hide all diagnostics besides error' }
)

-- pyrun
-- TODO: move this within the plugin?
keymap.set('n', '<leader>pr', ':Pyrun<cr>')

keymap.set('n', '<leader>fm', ':FringeModeToggle<cr>')

keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

-- go build
keymap.set('n', '<leader>gb', ':!go build $(git rev-parse --show-toplevel)<cr>')
keymap.set('n', '<leader>ta', ':set list<cr>|:set listchars=tab:>-,space:.<cr>')

-- goto next error
keymap.set('n', '<leader>en', ':lua vim.diagnostic.goto_next()<cr>')
keymap.set('n', '<leader>ep', ':lua vim.diagnostic.goto_prev()<cr>')

vim.keymap.set('n', '<leader>st', ':!tmux send-keys -t "ssh tunnels" C-p Enter<cr><cr>')

-- open up diff in a new tab
vim.keymap.set('n', '<leader>td', function()
  vim.fn.system "tmux new-window -n diff && tmux send-keys 'diff' Enter"
end, { desc = 'Open diff in new tmux window' })

vim.keymap.set('n', '<leader>au', function()
  local auth_file = vim.fn.expand '~/code/kulala/auth.http'
  vim.cmd('edit ' .. auth_file)
  require('kulala').run()
end, { desc = 'Run auth.http' })
