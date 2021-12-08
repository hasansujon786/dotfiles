local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = {'src/parser.c', 'src/scanner.cc'},
  },
  filetype = 'org',
}

require('orgmode').setup({
  org_agenda_files = {'~/vimwiki/**/*'},
  org_default_notes_file = '~/vimwiki/5_inbox/refile.org',
  org_hide_leading_stars = true,
  org_hide_emphasis_markers = true,
  org_agenda_templates = {
    f = { description = 'FileMark', template = '* %?\n  %a', target = '~/vimwiki/5_inbox/file-mark.org' },
  }
})
