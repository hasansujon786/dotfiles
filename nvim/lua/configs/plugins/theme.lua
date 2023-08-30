return {
  { 'navarasu/onedark.nvim', lazy = true },
  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    config = function()
      require('nvim-web-devicons').set_icon({
        scratchpad = {
          icon = '',
          color = '#6d8086',
          name = 'Scratchpad',
        },
        NeogitStatus = {
          icon = '',
          color = '#F14C28',
          name = 'BranchCycle',
        },
        DiffviewFiles = {
          icon = '',
          color = '#F14C28',
          name = 'TelescopePrompt',
        },
        org = {
          icon = '◉',
          color = '#75A899',
          name = 'Org',
        },
        ps1 = {
          icon = '',
          color = '#0074D0',
          name = 'ps1',
        },
      })
    end,
  },
}
