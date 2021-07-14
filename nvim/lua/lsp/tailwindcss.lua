-- TODO: what is a tailwindcss filetype
local lspconfig = require "lspconfig"
local lsp = require('lsp')

-- curl -L -o tailwindcss-intellisense.vsix https://github.com/tailwindlabs/tailwindcss-intellisense/releases/download/v0.6.13/vscode-tailwindcss-0.6.13.vsix
-- unzip tailwindcss-intellisense.vsix -d tailwindcss-intellisense
-- echo "#\!/usr/bin/env node\n$(cat tailwindcss-intellisense/extension/dist/server/tailwindServer.js)" > tailwindcss-language-server
-- chmod +x tailwindcss-language-server
lspconfig.tailwindcss.setup {
  cmd = { "node",
    "C:\\Users\\hasan\\tailwindcss-intellisense\\extension\\dist\\server\\tailwindServer.js",
    "--stdio",
  },
  filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html", "edge", "eelixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte" },
  root_dir = require("lspconfig/util").root_pattern("tailwind.config.js", "postcss.config.ts", ".postcssrc"),
  on_attach = lsp.on_attach
}
