local maps = require('hasan.utils.maps')
maps.nnoremap('-', '<cmd>call hasan#fern#vinager()<CR>') -- change in whichkey
maps.nnoremap('<BS>', '<cmd> call hasan#fern#edit_alternate()<CR>')

vim.g['fern#drawer_width'] = 26
vim.g['fern#keepalt_on_edit'] = 1
vim.g['fern#default_hidden'] = 1
vim.g['fern#disable_default_mappings'] = 1
vim.g['fern#disable_drawer_smart_quit'] = 1
vim.g['fern_git_status#disable_ignored'] = 1
vim.g['fern_git_status#disable_untracked'] = 1
vim.g['fern_git_status#disable_submodules'] = 1
vim.g['fern#default_exclude'] = '\\.git\\|node_modules'
vim.g['fern#hide_cursor'] = 1
vim.g['fern#renderer'] = 'nerdfont'
vim.g['fern#mark_symbol']                       = '●'
vim.g['fern#renderer#default#collapsed_symbol'] = '▷ '
vim.g['fern#renderer#default#expanded_symbol']  = '▼ '
vim.g['fern#renderer#default#leading']          = ' '
vim.g['fern#renderer#default#leaf_symbol']      = ' '
vim.g['fern#renderer#default#root_symbol']      = '~ '
