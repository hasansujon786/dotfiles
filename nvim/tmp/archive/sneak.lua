local nx = { 'n', 'x' }
return {
  'justinmk/vim-sneak',
  enabled = not vim.g.use_flash,
  keys = { { 's', mode = nx }, { 'S', mode = nx }, { 'z', mode = 'o' }, { 'Z', mode = 'o' } },
  init = function()
    vim.g['sneak#target_labels'] = ';wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789'
    vim.g['sneak#label'] = 1 -- use <tab> to jump through lebles
    vim.g['sneak#use_ic_scs'] = 1 -- case insensitive sneak
    vim.g['sneak#prompt'] = '  '
  end,
  config = function()
    -- Repeat the last Sneak
    keymap({ 'n', 'x' }, 'gs', '<Plug>Sneak_s<CR>')
    keymap({ 'n', 'x' }, 'gS', '<Plug>Sneak_S<CR>')

    vim.cmd([[
      hi Sneak guibg=#ccff88 guifg=black gui=bold
      hi! link SneakScope  IncSearch
    ]])

    local function is_sneaking()
      return vim.fn['sneak#is_sneaking']() == 1
    end

    keymap({ 'n', 'x' }, ';', function()
      return is_sneaking() and '<Plug>Sneak_;' or ';'
    end, { expr = true })
    keymap({ 'n', 'x' }, ',', function()
      return is_sneaking() and '<Plug>Sneak_,' or ','
    end, { expr = true })
  end,
}
