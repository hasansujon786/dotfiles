local cmd = vim.cmd
local opt = vim.opt

vim.g.mapleader=' '
vim.g.maplocalleader=' '

-- Files-backup-undo
cmd([[
if !has('win32')
  if !exists('$XDG_CACHE_HOME')
    let $XDG_CACHE_HOME = $HOME . '/.cache'
  end
  set undodir=$XDG_CACHE_HOME/vim_undo
  set viewdir=$XDG_CACHE_HOME/vim_views
else
  set undodir=$HOME/AppData/Local/nvim-data/undo
  set viewdir=$HOME/AppData/Local/nvim-data/views
end
]])
opt.backup = false
opt.swapfile = false                              -- Turn backup off, since most stuff is in SVN, git etc. anyway...
opt.writebackup = false
opt.undofile = true
opt.undolevels=1500                               -- persistent undo between file reloads
cmd('set viewoptions-=curdir')                    -- see: https://vi.stackexchange.com/questions/11903/working-directory-different-than-current-file-directory
cmd('set sessionoptions-=folds')

-- Spell
opt.spelllang='en_us'                             -- Speak proper English | en_gb
cmd('set complete+=kspell')                       -- Autocomplete with dictionary words when spell check is on
opt.spellfile='~/dotfiles/nvim/spell/en.utf-8.add'

-- Controls
opt.mouse='a'
opt.backspace={'eol','start','indent'}            -- Configure backspace so it acts as it should act
cmd('set path+=**')                               -- usefull while using find in nested folders
-- opt.clipboard = "unnamedplus"

opt.lazyredraw = true                             -- Don't redraw while executing macros (good performance config)
opt.updatetime=100
opt.timeout = true
opt.ttimeout = true
opt.ttimeoutlen=200
opt.timeoutlen=500                                -- Quickly time out on keycodes, but never time out on mappings
opt.autowrite = true                              -- Automatically :write before running commands
opt.autoread = true                               -- Set to auto read when a file is changed from the outside

-- Autocompletion
opt.completeopt = 'menuone,noselect'
opt.wildmenu = true
opt.wildignorecase = true
opt.shortmess:append('c')                         -- don't pass messages to |ins-completion-menu|
opt.wildoptions='pum'                             -- set file completion in command to use pum
opt.mousemodel='popup'
opt.pumblend=4                                    -- Set pum background transparent
opt.pumheight=10                                  -- Makes popup menu smaller
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

-- Ignore the following globs in file completions
cmd([[
set wildignore+=*.o,*~,*.pyc,*.obj,*.pyc,*.so,*.swp
set wildignore+=*.zip,*.jpg,*.gif,*.png,*.pdf
set wildignore+=.git,.hg,.svn,DS_STORE,bower_components,node_modules
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
]])
-- Ignore compiled files
-- opt.wildignore = "__pycache__"
-- opt.wildignore = opt.wildignore + { "*.o", "*~", "*.pyc", "*pycache*" }

-- ui
opt.ruler = true                                  -- Always show current position
opt.showmatch = true                              -- Show matching brackets when text indicator is over them
opt.cursorline = true                             -- Show a line on current line
opt.showcmd = true                                -- shows size of visual selection bellow statusline
opt.showmode = false                              -- don't show mode as lightline already does
opt.modeline = false
opt.modelines=0
opt.fillchars={eob=' ',vert= '░'}                 -- Suppress ~ at EndOfBuffer
opt.belloff = "all" -- Just turn the dang bell off
opt.guifont='CaskaydiaCove\\ NF:h16'
opt.guicursor='n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
opt.title = true
opt.titlestring = "%t  -  %{fnamemodify(getcwd(), ':t')}"  -- what the title of the window will be set to
-- if !exists('g:neovide')
-- endif

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth=4
opt.signcolumn='yes'                              -- Always show the signcolumn,

-- Tabline & Statusline
opt.showtabline=2
opt.laststatus=2

-- Windwo & buffer
opt.cmdheight=1                                   -- Height of the command bar
opt.equalalways = false                           -- I don't like my windows changing all the time
opt.splitright = true                             -- Prefer windows splitting to the right
opt.splitbelow = true                             -- Prefer windows splitting to the bottom
opt.hidden = true
opt.switchbuf='useopen'                           -- Specify the behavior when switching between buffers (enable hidden unsaved buffers)
-- set diffopt+=vertical                          -- Always use vertical diffs

-- Tabbing
local indent = 2
opt.shiftwidth = indent                           -- Size of an indent
opt.tabstop = indent                              -- Number of spaces tabs count for
opt.softtabstop = indent
opt.expandtab = true                              -- Use spaces instead of tabs
opt.autoindent = true
opt.smartindent = true

-- Searching
opt.magic = true                                  -- For regular expressions turn magic on
opt.regexpengine=1                                -- (good performance config)
opt.wrapscan = true                               -- Wrap searches.
opt.ignorecase = true
opt.smartcase = true                              -- Ignore search term case, unless term contains an uppercase character.
opt.infercase = true
opt.hlsearch = true
opt.incsearch = true                              -- Show where the pattern, as it was typed.
opt.gdefault = true                               -- The ':substitute' flag 'g' is default on.
opt.inccommand='nosplit'                          -- interactive find replace preview

-- Text appearance
opt.list = true
opt.joinspaces = false                            -- Two spaces and grade school, we're done
cmd('set iskeyword+=-')                           -- treat dash separated words as a word text object
cmd('set iskeyword-=#')                           -- Remove # from part of word
cmd('set matchpairs+=<:>,«:»,｢:｣')                -- Match angle brackets...
cmd('set listchars+=precedes:«,extends:»')
cmd('set listchars+=precedes:,extends:')
cmd('set listchars+=tab:→\\ ,nbsp:␣,trail:•')     -- show hidden characters
cmd('set whichwrap+=<,>,[,],h,l')                 -- Allow left/right & h/l key to move to the previous/next line
-- Scroll aside
opt.sidescroll=1
opt.scrolloff=1                                   -- Set 1 lines to the cursor - when moving vertically using j/k
opt.sidescrolloff=5
-- Wrappings
opt.textwidth=120                                 -- Hard-wrap text at nth column
opt.wrap = false                                  -- No wrap by default
opt.linebreak = true                              -- Don't break words when wrapping lines
opt.breakindent = true                            -- Every wrapped line will continue visually indented
opt.showbreak = string.rep(" ", 3)                -- Make it so that long lines wrap smartly
-- cmd('let &showbreak="↳ "')                         -- Make wrapped lines more obvious
cmd('set cpoptions+=n')

