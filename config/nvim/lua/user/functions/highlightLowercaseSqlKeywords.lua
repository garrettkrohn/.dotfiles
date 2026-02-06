local M = {}

function M.highlight_words(words)
  if vim.g.my_highlight_id then
    vim.fn.matchdelete(vim.g.my_highlight_id)
  end

  vim.cmd 'highlight default MyHighlight ctermfg=Black ctermbg=Green guifg=Black guibg=Green'

  local pattern = '\\<\\(' .. table.concat(words, '\\|') .. '\\)\\>'

  vim.g.my_highlight_id = vim.fn.matchadd('MyHighlight', pattern)
end

function M.reset_highlight()
  if vim.g.my_highlight_id then
    vim.fn.matchdelete(vim.g.my_highlight_id)
    vim.g.my_highlight_id = nil
  end

  vim.cmd 'highlight clear MyHighlight'
end

-- List of SQL keywords
local sql_keywords = {
  'and',
  'select',
  'insert',
  'update',
  'delete',
  'from',
  'where',
  'join',
  'inner',
  'left',
  'right',
  'full',
  'on',
  'group',
  'by',
  'order',
  'having',
  'limit',
  'offset',
  'distinct',
  'union',
  'all',
  'as',
  'in',
  'exists',
  'between',
  'like',
  'ilike',
  'not',
  'null',
  'is',
  'true',
  'false',
  'create',
  'alter',
  'drop',
  'table',
  'index',
  'view',
  'sequence',
  'trigger',
  'function',
  'procedure',
  'database',
  'schema',
  'grant',
  'revoke',
  'primary',
  'key',
  'foreign',
  'references',
  'check',
  'default',
  'constraint',
  'explain',
  'analyze',
  'vacuum',
  'reindex',
  'cluster',
  'comment',
  'copy',
  'with',
  'recursive',
  'cast',
  'type',
  'enum',
  'range',
  'collate',
  'extension',
  'language',
  'aggregate',
  'operator',
  'rule',
  'policy',
  'role',
  'user',
  'group',
  'login',
  'password',
  'inherit',
  'noinherit',
  'valid',
  'invalid',
  'rename',
  'owner',
  'set',
  'reset',
  'show',
  'start',
  'transaction',
  'commit',
  'rollback',
  'savepoint',
  'release',
  'prepare',
  'execute',
  'deallocate',
  'listen',
  'notify',
  'unlisten',
  'discard',
  'lock',
  'unlock',
  'disable',
  'enable',
  'reindex',
  'cluster',
  'analyze',
  'vacuum',
  'reindex',
  'cluster',
  'analyze',
  'vacuum',
}

vim.cmd(
  'command! HighlightLowercaseSqlKeywords lua require("user_functions.highlightLowercaseSqlKeywords").highlight_words(' .. vim.inspect(sql_keywords) .. ')'
)
vim.cmd 'command! ResetHighlight lua require("user_functions.highlightLowercaseSqlKeywords").reset_highlight()'

vim.keymap.set('n', '<leader>hi', function()
  M.highlight_words(sql_keywords)
end, { remap = true, silent = false, desc = 'Highlight sql keywords' })
vim.keymap.set('n', '<leader>hc', function()
  M.reset_highlight()
end, { remap = true, silent = false, desc = 'Cancel sql keyword highlight' })

return M
