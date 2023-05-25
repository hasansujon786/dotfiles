require('project_nvim').setup({
  detection_methods = { 'pattern' },
  exclude_dirs = { 'c:', 'c:/Users/hasan/dotfiles/nvim/.vsnip' },
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'pubspec.yaml' },
  show_hidden = true,
})
-- require('telescope').load_extension('projects')
