local nx = { 'n', 'x' }

return {
  'mg979/vim-visual-multi',
  keys = {
    { 'gb', '<Plug>(VM-Find-Under)', desc = 'VM: Select under cursor', mode = 'n' },
    { 'gb', '<Plug>(VM-Find-Subword-Under)', desc = 'VM: Select under cursor', mode = 'x' },
    { 'gB', '<Plug>(VM-Select-All)', desc = 'VM: Select all occurrences', mode = 'n' },
    { 'gB', '<Plug>(VM-Visual-All)', desc = 'VM: Select all occurrences', mode = 'x' },
    { 'gmA', '<Plug>(VM-Select-All)', desc = 'VM: Select all occurrences', mode = 'n' },
    { 'gmA', '<Plug>(VM-Visual-All)', desc = 'VM: Select all occurrences', mode = 'x' },
    { '<C-up>', mode = nx },
    { '<C-down>', mode = nx },
  },
  init = function()
    vim.g.VM_leader = 'gm'
    vim.g.VM_theme = ''
    vim.g.VM_maps = {
      -- ['Slash Search'] = 'gM',
      ['Find Under'] = 0,
      ['Find Subword Under'] = 0,
      ['I BS'] = '<C-h>',
    }
  end,
  config = function()
    augroup('MY_VM')(function(autocmd)
      autocmd('User', function()
        vim.api.nvim_set_hl(0, 'CurSearch', { link = 'None' })
      end, { pattern = 'visual_multi_start' })
      autocmd('User', function()
        vim.api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })
      end, { pattern = 'visual_multi_exit' })
    end)
  end,
}
