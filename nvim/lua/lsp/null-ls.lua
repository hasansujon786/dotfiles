-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require("null-ls")
local b = null_ls.builtins
local sources = {
  b.formatting.prettier,
  -- b.code_actions.eslint, -- eslint or eslint_d
  -- b.diagnostics.eslint, -- eslint or eslint_d

  -- b.diagnostics.eslint.with({
  --   only_local = "node_modules/.bin",
  --   -- prefer_local = "node_modules/.bin",
  --   condition = function(utils)
  --     return utils.root_has_file(".eslintrc.js")
  --   end,
  -- }),

}

null_ls.setup({ sources = sources })
