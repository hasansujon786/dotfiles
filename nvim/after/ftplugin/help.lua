-- Buffer-local options
vim.opt_local.number = true
vim.opt_local.relativenumber = false
vim.opt_local.readonly = true
vim.opt_local.modifiable = false
vim.opt_local.list = false

-- Buffer-local variables
vim.b.snacks_scope = false

-- Helper to merge buffer-local options with a description
local map = vim.keymap.set
local function bmap(mode, lhs, rhs, desc, extra_opts)
  local opts = vim.tbl_extend('force', { buffer = true, desc = desc }, extra_opts or {})
  map(mode, lhs, rhs, opts)
end

-- Jump to tag
bmap('n', 'gd', '<C-]>', 'Go to help tag')

-- Next / Previous help link (|link|)
bmap('n', ']v', [[/\v\|[^\|]+\|<CR><cmd>nohl<CR>]], 'Next help link', { silent = true, nowait = true })
bmap('n', '[v', [[?\v\|[^\|]+\|<CR><cmd>nohl<CR>]], 'Previous help link', { silent = true, nowait = true })
-- Next / Previous help tag definition (*tag*)
bmap('n', ']b', [[/\v\*[^*]+\*<CR><cmd>nohl<CR>]], 'Next help tag definition', { silent = true, nowait = true })
bmap('n', '[b', [[?\v\*[^*]+\*<CR><cmd>nohl<CR>]], 'Previous help tag definition', { silent = true, nowait = true })

-- Reading mode (recursive mappings to match `nmap`)
bmap('n', 'd', '<C-d>', 'Scroll half-page down', { nowait = true, remap = true })
bmap('n', 'u', '<C-u>', 'Scroll half-page up', { nowait = true, remap = true })
