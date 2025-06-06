local o = vim.o
local opt = vim.opt

-- Files-backup-undo
vim.loader.enable()
o.backup = false
o.swapfile = false --                            Turn backup off, since most stuff is in SVN, git etc. anyway...
o.writebackup = false
o.undofile = true
o.undolevels = 1500 --                           persistent undo between file reloads
o.sessionoptions = 'buffers,curdir,folds,globals,tabpages,winpos,winsize'
opt.viewoptions:remove({ 'folds', 'curdir' }) -- see: https://vi.stackexchange.com/questions/11903/working-directory-different-than-current-file-directory
-- Spell
opt.complete:append({ 'kspell' })
o.spellfile = '~/dotfiles/nvim/spell/en.utf-8.add'
-- Controls
o.mouse = 'a'
opt.backspace = { 'eol', 'start', 'indent' } --  Configure backspace so it acts as it should act
-- o.clipboard = "unnamedplus"

-- o.lazyredraw = true --                           Don't redraw while executing macros (good performance config)
-- o.shell="cmd.exe"
o.updatetime = 100
o.timeout = true
o.ttimeout = true
o.ttimeoutlen = 200
o.timeoutlen = 500 --                            Quickly time out on keycodes, but never time out on mappings
o.autowrite = true --                            Automatically :write before running commands
o.autoread = true --                             Set to auto read when a file is changed from the outside

-- Autocompletion
o.completeopt = 'menuone,noselect'
o.wildmenu = true
o.wildignorecase = true
opt.shortmess:append('c') --                     Don't pass messages to |ins-completion-menu|
o.wildoptions = 'pum' --                         Set file completion in command to use pum
o.mousemodel = 'popup'
-- o.pumblend = 4 --                             Set pum background transparent
o.pumheight = 10 --                              Makes popup menu smaller
-- Ignore the following globs in file completions
o.wildignore =
  '*.o,*~,*.pyc,*.obj,*.pyc,*.so,*.swp,*.zip,*.jpg,*.gif,*.png,*.pdf,.git,.hg,.svn,DS_STORE,bower_components,node_modules'
-- TODO: w, {v, b, l}
opt.formatoptions = opt.formatoptions
  - 'a' -- Auto formatting is BAD.
  - 't' -- Don't auto format my code. I got linters for that.
  + 'c' -- In general, I like it when comments respect textwidth
  + 'q' -- Allow formatting comments w/ gq
  - 'o' -- O and o, don't continue comments
  + 'r' -- But do continue when pressing enter.
  + 'n' -- Indent past the formatlistpat, not underneath it.
  + 'j' -- Auto-remove comments if possible.
  - '2' -- I'm not in gradeschool anymore

-- ui
o.ruler = true --                                Always show current position
o.showmatch = true --                            Show matching brackets when text indicator is over them
o.cursorline = true --                           Show a line on current line
o.showcmd = true --                              Shows size of visual selection bellow statusline
o.showmode = false --                            Don't show mode as lightline already does
o.modeline = false
o.modelines = 0
o.showtabline = 0
o.laststatus = 3
o.statusline = ' '
o.cmdheight = 0 --                               Height of the command bar
o.conceallevel = 2
o.concealcursor = ''
o.list = true
opt.listchars = {
  tab = '→ ',
  nbsp = '␣',
  trail = '•',
  extends = '›',
  precedes = '‹',
  -- space = "•",
  -- eol = "¬",
}
o.joinspaces = false --                          Two spaces and grade school, we're done
-- opt.iskeyword:append('-') --                     Treat dash separated words as a word text object
-- opt.matchpairs:append({'<:>','«:»','｢:｣'}) --    Match angle brackets...)
opt.whichwrap:append('<,>,[,],h,l') --           Allow left/right & h/l key to move to the previous/next line
-- code folding settings
o.foldtext = '' -- 'hasan#utils#foldtext()'
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldnestmax = 2 --                             Maximum nesting of folds
o.foldlevelstart = 99 --                         Sets 'foldlevel' when starting to edit a buffer
o.foldenable = true --                           Don't fold by default
o.foldcolumn = '0'
vim.opt.fillchars = {
  eob = ' ',
  diff = '╱',
  fold = ' ', -- ┄
  foldsep = '',
  foldclose = '˃',
  foldopen = '',
  vert = '▏',
  horiz = '▁',
  horizup = '🭼',
  horizdown = '▁',
  vertleft = '▏',
  vertright = '🭼',
  verthoriz = '🭼',
  -- vert = '┃',
  -- horiz = '▁',
  -- horizup = '┃',
  -- horizdown = ' ',
  -- vertleft = '┃',
  -- vertright = '┃',
  -- verthoriz = '┃',
}

o.belloff = 'all' --                             Just turn the dang bell off
o.guifont = 'OperatorMonoLig Nerd Font:h16' --   FiraCode NF:h12:w6
o.guicursor =
  'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
o.title = true
o.titlelen = 20
vim.o.titlestring = '%{fnamemodify(getcwd(), ":t")}'
-- o.quickfixtextfunc = '{info -> v:lua.require("hasan.utils.ui.qf").qftf(info)}'

-- Numbers
o.number = true
o.relativenumber = true
o.numberwidth = 3
o.signcolumn = 'yes' --                          Always show the signcolumn,

-- Windwo & buffer
o.equalalways = false --                         I don't like my windows changing all the time
o.splitright = true --                           Prefer windows splitting to the right
o.splitbelow = true --                           Prefer windows splitting to the bottom
o.hidden = true
o.switchbuf = 'useopen,uselast' --               Specify the behavior when switching between buffers (enable hidden unsaved buffers)
-- set diffopt+=vertical --                      Always use vertical diffs

-- Tabbing
local indent = 2
o.shiftwidth = indent --                         Size of an indent
o.tabstop = indent --                            Number of spaces tabs count for
o.softtabstop = indent
o.expandtab = true --                            Use spaces instead of tabs
o.autoindent = true
o.smartindent = true
o.fileformat = 'unix'

-- Searching
o.magic = true --                                For regular expressions turn magic on
o.termguicolors = true --                                For regular expressions turn magic on
o.regexpengine = 1 --                            (good performance config)
o.wrapscan = true --                             Wrap searches.
o.ignorecase = true
o.smartcase = true --                            Ignore search term case, unless term contains an uppercase character.
o.infercase = true
o.hlsearch = true
o.incsearch = true --                            Show where the pattern, as it was typed.
o.inccommand = 'nosplit' --                      Interactive find replace preview
o.grepprg = [[rg --hidden --smart-case --vimgrep]]
opt.path:append({ '**' })
-- opt.grepformat = { '%f:%l:%c:%m' }

-- Scroll aside
o.sidescroll = 1
o.scrolloff = 1 --                               Set 1 lines to the cursor - when moving vertically using j/k
o.sidescrolloff = 5
-- Wrappings
o.textwidth = 80 --                              Hard-wrap text at nth column
o.wrap = false --                                No wrap by default
o.linebreak = true --                            Don't break words when wrapping lines
o.breakindent = true --                          Every wrapped line will continue visually indented
-- o.showbreak = '↪  ' --                           Make it so that long lines wrap smartly
-- vim.wo.showbreak = '↪  ' --                           Make it so that long lines wrap smartly
opt.cpoptions:append('n')

vim.lsp.enable({ 'autohotkey_lsp' })
