-- line pseudo-text objects
-- ------------------------
-- il al
keymap('x', 'il', 'g_o^', { desc = 'inner line' })
keymap('o', 'il', '<cmd>normal vil<CR>', { desc = 'inner line' })
keymap('x', 'al', '$o0', { desc = 'line' })
keymap('o', 'al', '<cmd>normal val<CR>', { desc = 'line' })

-- number pseudo-text object (integer and float)
-- ---------------------------------------------
-- in
function VisualNumber()
  vim.fn.search([[\d\([^0-9\.]\|$\)]], 'cW')
  vim.cmd([[normal v]])
  vim.fn.search([[\(^\|[^0-9\.]\d\)]], 'becW')
end
keymap('x', 'in', ':lua VisualNumber()<CR>', { desc = 'inner number' })
keymap('o', 'in', ':<C-u>normal vin<CR>', { desc = 'inner number' })

-- buffer pseudo-text objects
-- --------------------------
-- ia aa
keymap('x', 'ia', [[0:<C-u>let z = @/|1;/^./kz<CR>G??<CR>:let @/ = z|nohlsearch<CR>V'z]], { desc = 'inner buffer' })
keymap('o', 'ia', '<cmd>normal via<CR>', { desc = 'inner buffer' })
keymap('x', 'aa', 'G$ogg0', { desc = 'buffer' })
keymap('o', 'aa', '<cmd>normal vaa<CR>', { desc = 'buffer' })

-- square brackets pseudo-text objects
-- -----------------------------------
-- ir ar
keymap('x', 'ir', 'i[', { desc = 'inner square brackets' })
keymap('o', 'ir', '<cmd>normal vi[<CR>', { desc = 'inner square brackets' })
keymap('x', 'ar', 'a[', { desc = 'square brackets' })
keymap('o', 'ar', '<cmd>normal va[<CR>', { desc = 'square brackets' })

-- last change pseudo-text objects
-- -------------------------------
-- ie ae
keymap('x', 'ie', '`]o`[', { desc = 'inner last change' })
keymap('o', 'ie', '<cmd>normal vie<CR>', { desc = 'inner last change' })
keymap('x', 'ae', '`]o`[V', { desc = 'last change' })
keymap('o', 'ae', '<cmd>normal vae<CR>', { desc = 'last change' })

-- block comment pseudo-text objects
-- ---------------------------------
-- i? a?
keymap('x', 'i?', '[*jo]*k', { desc = 'inner block comment' })
keymap('o', 'i?', '<cmd>normal vi?V<CR>', { desc = 'inner block comment' })
keymap('x', 'a?', '[*o]*', { desc = 'block comment' })
keymap('o', 'a?', '<cmd>normal va?V<CR>', { desc = 'block comment' })

-- 24 simple pseudo-text objects
-- -----------------------------
-- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
-- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
for _, char in ipairs({ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '-', '#' }) do
  keymap('x', 'i' .. char, string.format(':<C-u>normal! T%svt%s<CR>', char, char), { desc = 'which_key_ignore' })
  keymap('o', 'i' .. char, string.format(':normal vi%s<CR>', char), { desc = 'which_key_ignore' })
  keymap('x', 'a' .. char, string.format(':<C-u>normal! F%svf%s<CR>', char, char), { desc = 'which_key_ignore' })
  keymap('o', 'a' .. char, string.format(':normal va%s<CR>', char), { desc = 'which_key_ignore' })
end

-- hasan/mahmud/sujon
-- hasan_mahmud_sujon
-- hasan-mahmud-sujon
-- hasan.mahmud.sujon
-- hasan#mahmud#sujon
-- hasan,mahmud,sujon
-- hasan*mahmud*sujon
-- hasan:mahmud:sujon
