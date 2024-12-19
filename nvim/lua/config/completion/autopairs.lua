return {
  'windwp/nvim-autopairs',
  lazy = true,
  config = function()
    require('nvim-autopairs').setup()

    local cmp_ok, cmp = pcall(require, 'cmp')
    if cmp_ok then
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end

    vim.defer_fn(function()
      keymap({ 's' }, '<BS>', '<C-r>_<BS>i')
      keymap({ 's' }, '<DEL>', '<C-r>_<BS>i')
    end, 10)

    -- CUSTOM RULES (Coppied from https://github.com/chrisgrieser/.config/blob/ee1d4eb9b83601c5ad60c81d5c68c0a28878d3ea/nvim/lua/plugins/editing-support.lua#L41C2-L41C2)
    -- DOCS https://github.com/windwp/nvim-autopairs/wiki/Rules-API
    local rule = require('nvim-autopairs.rule')
    local isNodeType = require('nvim-autopairs.ts-conds').is_ts_node
    local isNotNodeType = require('nvim-autopairs.ts-conds').is_not_ts_node
    local negLookahead = require('nvim-autopairs.conds').not_after_regex
    local notBefore = require('nvim-autopairs.conds').not_before_text

    require('nvim-autopairs').add_rules({
      rule('<', '>', 'lua'):with_pair(isNodeType({ 'string', 'string_content' })),
      rule('<', '>', { 'vim', 'html', 'xml' }), -- keymaps & tags
      rule('*', '*', 'markdown'), -- italics
      rule('![', ']()', 'markdown'):set_end_pair_length(1), -- images

      -- git conventional commit with scope: auto-append `:`
      rule('^%a+%(%)', ':', 'gitcommit')
        :use_regex(true)
        :with_pair(negLookahead('.+'))
        :with_pair(isNotNodeType('message'))
        :with_move(function(opts)
          return opts.char == ':'
        end),

      -- auto-add trailing semicolon, but only for declarations
      -- (which are at the end of the line and have no text afterwards)
      rule(':', ';', 'css'):with_pair(negLookahead('.+')),

      -- add brackets to if/else in js/ts
      rule('^%s*if $', '()', { 'javascript', 'typescript' })
        :use_regex(true)
        :with_del(function()
          return false
        end)
        :set_end_pair_length(1), -- only move one char to the side
      rule('^%s*else if $', '()', { 'javascript', 'typescript' })
        :use_regex(true)
        :with_del(function()
          return false
        end)
        :set_end_pair_length(1),
      rule('^%s*} ?else if $', '() {', { 'javascript', 'typescript' })
        :use_regex(true)
        :with_del(function()
          return false
        end)
        :set_end_pair_length(3),

      -- add colon to if/else in python
      rule('^%s*e?l?if$', ':', 'python')
        :use_regex(true)
        :with_del(function()
          return false
        end)
        :with_pair(isNotNodeType('string_content')), -- no docstrings
      rule('^%s*else$', ':', 'python')
        :use_regex(true)
        :with_del(function()
          return false
        end)
        :with_pair(isNotNodeType('string_content')), -- no docstrings
      rule('', ':', 'python') -- automatically move past colons
        :with_move(function(opts)
          return opts.char == ':'
        end)
        :with_pair(function()
          return false
        end)
        :with_del(function()
          return false
        end)
        :with_cr(function()
          return false
        end)
        :use_key(':'),

      -- quicker template string
      rule('$', '{}', { 'javascript', 'typescript' })
        :with_pair(negLookahead('{', 1))
        :with_pair(isNodeType({ 'string', 'template_string', 'string_fragment' }))
        :set_end_pair_length(1),
    })
  end,
}
