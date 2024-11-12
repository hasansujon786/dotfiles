local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  { 'tpope/vim-repeat', lazy = true, event = 'BufReadPost', dependencies = 'tpope/vim-surround' },
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      timeout = 350, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      mappings = {
        i = { j = { k = '<Esc>', j = false } },
        c = { j = { k = '<Esc>', j = false } },
        t = { j = { k = '<Esc>', j = false } },
        s = { j = { k = '<Esc>' } },
        v = { j = { k = false } },
      },
    },
  },
  {
    'dhruvasagar/vim-table-mode',
    cmd = { 'TableModeToggle', 'TableModeEnable', 'TableModeRealign' },
  },
  -- require("hasan.neo_glance")
}
