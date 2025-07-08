local nx = { 'n', 'x' }

return {
  'mg979/vim-visual-multi',
  keys = {
    { 'gb', '<Plug>(VM-Find-Under)', desc = 'VM: Select under cursor', mode = 'n' },
    { 'gb', '<Plug>(VM-Find-Subword-Under)', desc = 'VM: Select under cursor', mode = 'x' },
    { 'gA', '<Plug>(VM-Select-All)', desc = 'VM-Select-All)', mode = nx },
    { 'gmA', desc = 'VM-Select-All)', mode = nx },
    { '<C-up>', mode = nx },
    { '<C-down>', mode = nx },
    { 'gmc', 'vip<Plug>(VM-Visual-Cursors)', mode = 'n' },
    { 'gmc', '<Plug>(VM-Visual-Cursors)', mode = 'x' },
    { '<C-LeftMouse>', '<Plug>(VM-Mouse-Cursor)' },
    { '<C-S-LeftMouse>', '<Plug>(VM-Mouse-Word)' },
    { '<M-RightMouse>', '<Plug>(VM-Mouse-Column)' },
  },
  init = function()
    local maps = vim.g.VM_maps or {}
    maps['Find Under'] = 0
    maps['Find Subword Under'] = 0
    maps['gc'] = 'gC'
    maps['I BS'] = '<C-h>'
    maps['Reselect Last'] = 'gmG'

    vim.g.VM_maps = maps
    vim.g.VM_leader = 'gm'
    vim.g.VM_theme = ''
    vim.g.VM_show_warnings = 1
  end,
  config = function()
    augroup('MY_VM')(function(autocmd)
      autocmd('User', function()
        local none = { link = 'None' }
        local highlights = {
          CurSearch = none,
          LspReferenceText = none,
          LspReferenceRead = none,
          LspReferenceWrite = none,
        }

        for hlName, option in pairs(highlights) do
          vim.api.nvim_set_hl(0, hlName, option)
        end
      end, { pattern = 'visual_multi_start' })

      autocmd('User', function()
        local c = require('hasan.utils.ui.palette').colors
        local highlights = {
          CurSearch = { link = 'IncSearch' },
          LspReferenceText = { bg = c.dim_green },
          LspReferenceRead = { bg = c.dim_green },
          LspReferenceWrite = { bg = c.dim_red },
        }

        for hlName, option in pairs(highlights) do
          vim.api.nvim_set_hl(0, hlName, option)
        end
      end, { pattern = 'visual_multi_exit' })
    end)
  end,
}
