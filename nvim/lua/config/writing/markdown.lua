return {
  { 'dhruvasagar/vim-table-mode', cmd = { 'TableModeToggle', 'TableModeEnable', 'TableModeRealign' } },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    -- build = 'cd app && yarn install',
    build = function()
      require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 0
    end,
    ft = { 'markdown' },
  },
}
