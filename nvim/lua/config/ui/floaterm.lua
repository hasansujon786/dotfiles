return {
  'voldikss/vim-floaterm',
  lazy = true,
  cmd = { 'FloatermNew', 'FloatermToggle' },
  keys = {
    { '<A-m>', '<cmd>FloatermToggle<CR>',                                             desc = 'Toggle terminal window' },
    { '<leader>ot', '<cmd>FloatermNew --wintype=normal --height=12<CR>',              desc = 'Open terminal split' },
    { '<leader>oT', '<cmd>FloatermNew<CR>',                                           desc = 'Open terminal popup' },
    { '<leader>of', '<cmd>FloatermNew --height=1.0 --width=1.0 --opener=edit lf<CR>', desc = 'Open lf' },
    { '<leader>gl', '<cmd>FloatermNew --height=1.0 --width=1.0 lazygit<CR>',          desc = 'Open lazygit' },
    { '<leader>gt', '<cmd>FloatermNew --height=1.0 --width=1.0 tig<CR>',              desc = 'Open tig' },
  },
  init = function()
    vim.g.floaterm_keymap_new = '<C-\\>c'
    vim.g.floaterm_keymap_prev = '<C-\\>p'
    vim.g.floaterm_keymap_next = '<C-\\>n'
    vim.g.floaterm_keymap_kill = '<A-q>'
    vim.g.floaterm_keymap_toggle = '<A-m>'
    keymap('n', ']t', '<cmd>FloatermToggle<CR><C-\\><C-n>')
    keymap('n', '[t', '<cmd>FloatermToggle<CR><C-\\><C-n>')

    -- Handle nebulous on floaterm WinClosed
    local function on_closed(info)
      augroup('FTERM_NESTED')(function(autocmd)
        autocmd({ 'WinClosed' }, function(_)
          vim.defer_fn(require('nebulous').update_all_windows, 30)
        end, { buffer = info.buf })
      end)
    end
    augroup('FTERM')(function(autocmd)
      autocmd({ 'User' }, on_closed, { pattern = 'FloatermOpen' })
    end)
  end,
  config = function()
    -- Configs
    vim.g.floaterm_shell = 'bash'
    vim.g.floaterm_width = 0.9
    vim.g.floaterm_height = 0.9
    vim.g.floaterm_title = '─$1/$2'
    vim.g.floaterm_borderchars = '─│─│╭╮╯╰'
    -- vim.g.floaterm_borderchars = '▀▐▄▌▛▜▟▙'
    vim.g.floaterm_autoclose = 2
    vim.g.floaterm_autohide = 2
  end,
}
