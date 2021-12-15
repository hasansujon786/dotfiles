-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require("null-ls")
local b = null_ls.builtins
local sources = {
  b.formatting.prettier,
}

null_ls.setup({ sources = sources })
