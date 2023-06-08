require('project_nvim').setup({
  detection_methods = { 'pattern' },
  exclude_dirs = { 'c:', 'c:/Users/hasan/dotfiles/nvim/.vsnip' },
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'pubspec.yaml' }, -- 'package.json'
  show_hidden = true,
})
-- require('telescope').load_extension('projects')
