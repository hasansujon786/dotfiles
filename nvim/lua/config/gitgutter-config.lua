
local maps = require('hasan.utils.maps')
maps.nmap(']c', '<Plug>(GitGutterNextHunk)')
maps.nmap('[c', '<Plug>(GitGutterPrevHunk)')
maps.nmap('<leader>gp', '<Plug>(GitGutterPreviewHunk)')
maps.nmap('<leader>gs', '<Plug>(GitGutterStageHunk)')
maps.nmap('<leader>gr', '<Plug>(GitGutterUndoHunk)')
maps.nmap('<leader>gq', ':GitGutterQuickFix | copen<CR>')
maps.nmap('<leader>g.', ':silent !git add %<CR>')

maps.omap('ih', '<Plug>(GitGutterTextObjectInnerPending)')
maps.omap('ah', '<Plug>(GitGutterTextObjectOuterPending)')
maps.xmap('ih', '<Plug>(GitGutterTextObjectInnerVisual)')
maps.xmap('ah', '<Plug>(GitGutterTextObjectOuterVisual)')
