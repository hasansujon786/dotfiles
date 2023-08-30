return {
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup()

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

    vim.defer_fn(function()
      keymap({ 's' }, '<BS>', '<C-r>_<BS>i')
      keymap({ 's' }, '<DEL>', '<C-r>_<BS>i')
    end, 10)
  end,
}
