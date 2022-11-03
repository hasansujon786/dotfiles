local lspconfig = require('lspconfig')
local lsp = require('lsp')

-- "C:\\Users\\hasan\\tailwindcss-intellisense\\extension\\dist\\server\\tailwindServer.js",
lspconfig.tailwindcss.setup {
  cmd = {
    "node",
    vim.fn.stdpath('data').."/lsp-servers/tailwindcss-ls/tailwindcss-intellisense/extension/dist/server/tailwindServer.js",
    "--stdio",
  },
  filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html", "edge", "eelixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte" },
  root_dir = require("lspconfig/util").root_pattern("tailwind.config.js", "postcss.config.ts", ".postcssrc"),
  on_attach = lsp.on_attach
}
