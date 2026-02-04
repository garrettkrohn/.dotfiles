-- Consolidated Markdown Plugin Configuration
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    config = {
      require('render-markdown').setup {
        link = {
          enabled = true,
          render_modes = false,
          footnote = {
            enabled = true,
            superscript = true,
            prefix = '',
            suffix = '',
          },
          image = '󰥶 ',
          email = '󰀓 ',
          hyperlink = '󰌹 ',
          highlight = 'RenderMarkdownLink',
          wiki = {
            icon = '󱗖 ',
            body = function()
              return nil
            end,
            highlight = 'RenderMarkdownWikiLink',
          },
          custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
            youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
          },
        },
        callout = {
          note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
          tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
          important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
          warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
          caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
          abstract = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo' },
          summary = { raw = '[!SUMMARY]', rendered = '󰨸 Summary', highlight = 'RenderMarkdownInfo' },
          tldr = { raw = '[!TLDR]', rendered = '󰨸 Tldr', highlight = 'RenderMarkdownInfo' },
          info = { raw = '[!INFO]', rendered = '󰋽 Info', highlight = 'RenderMarkdownInfo' },
          todo = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownInfo' },
          hint = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess' },
          success = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess' },
          check = { raw = '[!CHECK]', rendered = '󰄬 Check', highlight = 'RenderMarkdownSuccess' },
          done = { raw = '[!DONE]', rendered = '󰄬 Done', highlight = 'RenderMarkdownSuccess' },
          question = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn' },
          help = { raw = '[!HELP]', rendered = '󰘥 Help', highlight = 'RenderMarkdownWarn' },
          faq = { raw = '[!FAQ]', rendered = '󰘥 Faq', highlight = 'RenderMarkdownWarn' },
          attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn' },
          failure = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError' },
          fail = { raw = '[!FAIL]', rendered = '󰅖 Fail', highlight = 'RenderMarkdownError' },
          missing = { raw = '[!MISSING]', rendered = '󰅖 Missing', highlight = 'RenderMarkdownError' },
          danger = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError' },
          error = { raw = '[!ERROR]', rendered = '󱐌 Error', highlight = 'RenderMarkdownError' },
          bug = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError' },
          example = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint' },
          quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote' },
          cite = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote' },
        },
        checkbox = {
          enabled = true,
          render_modes = false,
          bullet = false,
          right_pad = 1,
          unchecked = {
            icon = '󰄱 ',
            highlight = 'RenderMarkdownUnchecked',
            scope_highlight = nil,
          },
          checked = {
            icon = '󰱒 ',
            highlight = 'RenderMarkdownChecked',
            scope_highlight = nil,
          },
          custom = {
            todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
          },
        },
        bullet = {
          enabled = true,
          render_modes = false,
          icons = { '●', '○', '◆', '◇' },
          ordered_icons = function(ctx)
            local value = vim.trim(ctx.value)
            local index = tonumber(value:sub(1, #value - 1))
            return ('%d.'):format(index > 1 and index or ctx.index)
          end,
          left_pad = 0,
          right_pad = 0,
          highlight = 'RenderMarkdownBullet',
          scope_highlight = {},
        },
        quote = { icon = '▋' },
        anti_conceal = {
          enabled = true,
          ignore = {
            code_background = true,
            sign = true,
          },
          above = 0,
          below = 0,
        },
      },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    enabled = false,
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
