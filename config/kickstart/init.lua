--  _____        __      ___
-- |  __ \       \ \    / (_)
-- | |  | |_ __   \ \  / / _ _ __ ___
-- | |  | | '__|   \ \/ / | | '_ ` _ \
-- | |__| | |_      \  /  | | | | | | |
-- |_____/|_(_)      \/   |_|_| |_| |_|

require 'config.options'
require 'config.lazy-bootstrap'
require 'config.lazy-plugins'
require 'config.keymaps'
require 'config.treesitter-setup'
-- require 'config.lsp-setup'
require 'config.autocommands'
-- require 'config.snippets'
require 'config.user_functions'

vim.cmd [[
    highlight TelescopeBorder guifg=#89b4fa 
    highlight TelescopePromptBorder guifg=#a6e3a1
    highlight TelescopePreviewBorder guifg=#f5c2e7
]]
