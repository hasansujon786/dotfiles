local M = {}

M.theme = {
  transparency = true,
}

M.treesitter = {
  auto_conceal_html_class = true,
  enabled_context = true,
}

---@type StateCompletion
M.completion = {
  module = 'blink',
}

M.lsp = {
  ---lspconfig_name = {'mason_package_name'}
  essential_servers = {
    -- Frontend
    html = { 'html-lsp' },
    cssls = { 'css-lsp' },
    ts_ls = { 'typescript-language-server' },
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
  },
  -- use_builtin_lsp_formatter = { 'dartls', 'astro', 'null-ls' },
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
      filetype = { 'bash', 'sh' },
      formatter = { 'shfmt' },
    },
    {
      filetype = '_', -- "_" filetypes that don't have other formatters configured.
      formatter = { 'trim_whitespace' },
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
    persists = true,
  },
  neominimap = {
    width = 90,
    height = 15,
  },
  telescope_border_style = 'edged',
  hover = {
    -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
    winhighlight = 'Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:CursorLineFocus,Search:None',
    border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  },
  edgy = {
    open_flutter_log_on_right = true,
  },
  neotree = {
    source_selector_style = 'minimal', -- defalut | minimal
  },
}

M.project = {
  todo_keyfaces = { 'TODO', 'DONE', 'INFO', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'OPTIM', 'OPTIMIZE' },
}

M.border_groups = {
  rounded = {
    prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
    results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
    preview = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
  },
  edged = {
    prompt = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    results = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    -- results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },
  },
  edged_top = {
    prompt = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    preview = { '▔', '▕', ' ', '▏', '🭽', '🭾', '▕', '▏' },
    results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },
  },
  edged_ivy = {
    prompt = { '▔', ' ', ' ', ' ', '▔', '▔', ' ', ' ' },
    results = { ' ', '▕', ' ', ' ', ' ', '▕', '▕', ' ' },
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
  empty = {
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
}

return M
