-- Repeat the last Sneak
keymap({ 'n', 'x' }, 'gs', '<Plug>Sneak_s<CR>')
keymap({ 'n', 'x' }, 'gS', '<Plug>Sneak_S<CR>')

keymap({ 'n', 'x' }, ';', "sneak#is_sneaking() ? '<Plug>Sneak_;' : ';'", { expr = true })
keymap({ 'n', 'x' }, ',', "sneak#is_sneaking() ? '<Plug>Sneak_,' : ','", { expr = true })
