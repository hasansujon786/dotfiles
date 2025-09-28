local map = vim.keymap.set

-- line pseudo-text objects
-- ------------------------
-- il al
map('x', 'il', 'g_o^', { desc = 'inner line' })
map('o', 'il', '<cmd>normal vil<CR>', { desc = 'inner line' })
map('x', 'al', '$o0', { desc = 'line' })
map('o', 'al', '<cmd>normal val<CR>', { desc = 'line' })

-- number pseudo-text object (integer and float)
-- ---------------------------------------------
-- in
local function visual_number()
  vim.cmd([[normal v]])
  vim.fn.search([[\d\([^0-9\.]\|$\)]], 'cW')
  vim.cmd([[normal v]])
  vim.fn.search([[\(^\|[^0-9\.]\d\)]], 'becW')
end
map('x', 'in', visual_number, { desc = 'inner number' })
map('o', 'in', '<cmd>normal vin<CR>', { desc = 'inner number' })

-- buffer pseudo-text objects
-- --------------------------
-- ie ae
map('x', 'ie', [[0:<C-u>let z = @/|1;/^./kz<CR>G??<CR>:let @/ = z|nohlsearch<CR>V'z]], { desc = 'inner buffer' })
map('o', 'ie', '<cmd>normal vie<CR>', { desc = 'inner buffer' })
map('x', 'ae', 'G$ogg0', { desc = 'buffer' })
map('o', 'ae', '<cmd>normal vae<CR>', { desc = 'buffer' })

-- square brackets pseudo-text objects
-- -----------------------------------
-- ir ar
map('x', 'ir', 'i[', { desc = 'inner square brackets' })
map('o', 'ir', '<cmd>normal vi[<CR>', { desc = 'inner square brackets' })
map('x', 'ar', 'a[', { desc = 'square brackets' })
map('o', 'ar', '<cmd>normal va[<CR>', { desc = 'square brackets' })

-- last change pseudo-text objects
-- -------------------------------
-- ie ae
-- map('x', 'ie', '`]o`[', { desc = 'inner last change' })
-- map('o', 'ie', '<cmd>normal vie<CR>', { desc = 'inner last change' })
-- map('x', 'ae', '`]o`[V', { desc = 'last change' })
-- map('o', 'ae', '<cmd>normal vae<CR>', { desc = 'last change' })

-- block comment pseudo-text objects
-- ---------------------------------
-- i? a?
map('x', 'i?', '[*jo]*k', { desc = 'inner block comment' })
map('o', 'i?', '<cmd>normal vi?V<CR>', { desc = 'inner block comment' })
map('x', 'a?', '[*o]*', { desc = 'block comment' })
map('o', 'a?', '<cmd>normal va?V<CR>', { desc = 'block comment' })

-- 24 simple pseudo-text objects
-- -----------------------------
-- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
-- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
local simple_objects = {
  inner = function(char)
    return function()
      vim.cmd(string.format('normal! T%sot%s', char, char))
    end
  end,
  outer = function(char)
    return function()
      vim.cmd(string.format('normal! F%sof%s', char, char))
    end
  end,
}
for _, char in ipairs({ '_', '.', ':', ',', '<bar>', '/', '<bslash>', '*', '-', '#' }) do
  map('x', 'i' .. char, simple_objects.inner(char), { desc = 'which_key_ignore' })
  map('o', 'i' .. char, string.format('<cmd>normal vi%s<CR>', char), { desc = 'which_key_ignore' })
  map('x', 'a' .. char, simple_objects.outer(char), { desc = 'which_key_ignore' })
  map('o', 'a' .. char, string.format('<cmd>normal va%s<CR>', char), { desc = 'which_key_ignore' })
end

-- hasan/mahmud/sujon
-- hasan_mahmud_sujon
-- hasan-mahmud-sujon
-- hasan.mahmud.sujon
-- hasan#mahmud#sujon
-- hasan,mahmud,sujon
-- hasan*mahmud*sujon
-- hasan:mahmud:sujon
