-- Alternate https://github.com/kndndrj/nvim-dbee
return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    -- { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  keys = {
    { '<leader>od', '<cmd>lua handle_win_cmd("DBUI")<CR>', desc = 'Open dadbod' },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- choco install mongodb-shell
    -- Your DBUI configuration
    vim.g.db_ui_win_position = 'right'
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
