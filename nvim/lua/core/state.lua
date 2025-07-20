local transparency = true

---@class state
---@field lsp state.Lsp
---@field completion state.Completion
local M = {}

M.theme = {
  transparency = transparency,
}

M.treesitter = {
  auto_conceal_html_class = true,
  enabled_context = true,
}

M.completion = {
  module = 'blink',
}

M.picker = {
  exclude = {
    -- dotfiles
    'gui/sublime_text/',
    'nvim/tmp/archive',
    '4_archive/',
    -- projects
    'android/',
    'ios/',
    'vendor/',
    'pubspec.lock',
  },
}

M.lsp = {
  ---lspconfig_name = {'mason_package_name'}
  essential_servers = {
    -- Frontend
    html = { 'html-lsp' },
    cssls = { 'css-lsp' },
    vtsls = { 'vtsls' },
    -- ts_ls = { 'typescript-language-server' },
    jsonls = { 'json-lsp' },
    eslint = { 'eslint-lsp' },
    -- Frameworks
    astro = { 'astro-language-server' },
    volar = { 'vue-language-server' }, -- vuels = { 'vetur-vls' },
    tailwindcss = { 'tailwindcss-language-server' },
    -- Lsps
    bashls = { 'bash-language-server' },
    lua_ls = { 'lua-language-server' },
    vimls = { 'vim-language-server' },
    gopls = { 'gopls' },
  },
  extra_tools = {
    'shfmt',
    'shellcheck',
    'stylua',
    'prettierd',
    'dart-debug-adapter',
    'js-debug-adapter',
    'harper-ls'
  },
  use_builtin_lsp_formatter = {},
  default_opts = {
    flags = { debounce_text_changes = 500 },
    -- capabilities = {},
  },
  linters_by_ft = {
    sh = { 'shellcheck' },
  },
  formatters_by_ft = {
    {
      filetype = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'css',
        'scss',
        'less',
        'html',
        'json',
        'jsonc',
        'yaml',
        'markdown',
        'markdown.mdx',
        'graphql',
        'handlebars',
      },
      formatter = { 'prettierd', 'prettier', stop_after_first = true },
    },
    {
      filetype = 'lua',
      formatter = { 'stylua' },
    },
    {
      filetype = 'dart',
      formatter = { lsp_format = 'fallback' },
    },
    {
      filetype = 'astro',
      formatter = { lsp_format = 'fallback' },
    },
    {
      filetype = { 'bash', 'sh' },
      formatter = { 'shfmt' },
    },
    {
      filetype = '_', -- "_" filetypes that don't have other formatters configured.
      formatter = { 'trim_whitespace' },
    },
  },
  diagnosgic = {
    sign = {
      use_dim_bg = false,
    },
  },
}

M.ui = {
  border = {
    style = 'rounded',
    highlight = 'DiagnosticHint',
  },
  session_autoload = false,
  fold = {
    persists = false,
  },
  neominimap = {
    width = 90,
    height = 15,
  },
  hover = {
    -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    winhighlight = 'Normal:NormalFloatFlat,FloatBorder:FloatBorderFlat,CursorLine:CursorLineFocus,Search:None',
    border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  },
  edgy = {
    open_flutter_log_on_right = true,
  },
  neotree = {
    source_selector_style = 'minimal', -- default | minimal
  },
}

M.project = {
  todo = {
    keyfaces = { 'TODO', 'DONE', 'INFO', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'OPTIM', 'OPTIMIZE' },
    exclude = {
      'nvim/lua/config/lsp/servers/dartls/bloc.lua',
    },
  },
}

return M
