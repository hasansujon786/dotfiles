# [[ -f "$HOME/dotfiles/shell/zsh/zshrc.zsh" ]] && source "$HOME/dotfiles/shell/zsh/zshrc.zsh"
# =========================================================
# ~/.zshrc — portable, multi-machine dotfiles version
# Works across Linux/macOS, different usernames, with/without
# Nushell, Homebrew, Bun, Atuin.
#
# Loaded from:  source ~/dotfiles/shell/zsh/zshrc.zsh
# Split modules (rarely changed) live in this folder:
#   completion.zsh    - compinit & zstyle completion rules
#   highlighting.zsh  - syntax highlighting & autosuggestions
# =========================================================

# =========================================================
# HAND OFF TO NUSHELL (if installed)
# Comment this block out if you want to stay in zsh by default.
# =========================================================
# if command -v nu >/dev/null 2>&1; then
#     exec nu
# fi



# =========================================================
# PATH
# Install-path additions are guarded so they work on any
# machine even when the tool isn't installed yet.
# =========================================================
export PATH="$PATH":"$HOME/.pub-cache/bin"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d /opt/homebrew/opt/openjdk@17 ] && export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
[ -d /opt/homebrew/opt/rustup ] && export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
[ -d "$HOME/.cargo" ] && export PATH="$HOME/.cargo/bin:$PATH"

export ANDROID_HOME="$HOME/Library/Android/sdk"
[ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$PATH:$ANDROID_HOME/platform-tools"


# =========================================================
# CORE SHELL OPTIONS
# =========================================================
setopt autocd              # cd by typing a directory name
#setopt correct            # auto correct mistakes (off by default)
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # filename expansion for arguments like "anything=expression"
setopt nonomatch           # hide error if a glob pattern has no match
setopt notify              # report background job status immediately
setopt numericglobsort     # sort filenames numerically when possible
setopt promptsubst         # enable command substitution in prompt

WORDCHARS='_-'             # don't treat these as word boundaries

# Hide the '%' EOL marker some terminals show
PROMPT_EOL_MARK=""


# =========================================================
# KEYBINDINGS
# =========================================================
bindkey -e                                         # emacs-style bindings
bindkey ' ' magic-space                            # history expansion on space
bindkey '^U' backward-kill-line                    # ctrl + U
bindkey '^[[1;5C' forward-word                     # ctrl + ->
bindkey '^[[3;5~' kill-word                        # ctrl + Delete
bindkey '^[[1;5D' backward-word                    # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history     # page up
bindkey '^[[6~' end-of-buffer-or-history           # page down
bindkey '^[[H' beginning-of-line                   # home
bindkey '^[[F' end-of-line                         # end
bindkey '^[[Z' undo                                # shift + tab undo


# =========================================================
# HISTORY
# =========================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000
setopt hist_expire_dups_first  # delete dupes first when HISTFILE exceeds HISTSIZE
setopt hist_ignore_dups        # ignore duplicate commands in history
setopt hist_ignore_space       # ignore commands that start with a space
setopt hist_verify             # confirm history-expanded command before running
#setopt share_history          # share history across sessions live (off by default)

alias history="history 0"      # show full history

# `time` command output format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'


# =========================================================
# CHROOT DETECTION (Debian/Kali-style environments)
# =========================================================
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# =========================================================
# COLOR PROMPT DETECTION
# =========================================================
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Force color prompt by default (assumes modern terminal emulator)
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# =========================================================
# STYLISH PROMPT CONFIGURATION
# Two-line "boxed" prompt with rounded-feel corners using
# box-drawing chars. Color scheme: cyan/magenta accents.
# NOTE: when Oh My Zsh is loaded below, its theme (candy)
# takes over the final prompt — this block remains useful on
# machines without OMZ.
# =========================================================
configure_prompt() {
    prompt_symbol=㉿
    # Uncomment to show a skull emoji when running as root
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀

    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.magenta.cyan)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.magenta)}%n'$prompt_symbol$'%m%b%F{%(#.magenta.cyan)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.magenta.cyan)}]\n└─%B%(#.%F{red}#.%F{cyan}❯)%b%F{reset} '
            # Right-side prompt: exit code + background job indicator
            RPROMPT=$'%(?.. %F{red}%B⨯ %?%b%F{reset})%(1j. %F{yellow}%B⚙ %j%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.magenta)}%n@%m%b%F{reset}:%B%F{%(#.cyan.cyan)}%~%b%F{reset}%(#.#.❯) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# --- Prompt mode toggles (Ctrl+P switches between oneline/twoline) ---
# These markers are kept intact for compatibility with Kali-derived configs
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1   # we render venv indicator ourselves above
    configure_prompt
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt


# =========================================================
# TERMINAL TITLE (xterm-compatible terminals, incl. WezTerm/Alacritty)
# =========================================================
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty|wezterm)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    print -Pnr -- "$TERM_TITLE"

    # blank line before each prompt (skip on the very first prompt)
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}


# =========================================================
# LS / GREP / DIFF COLOR SUPPORT
# =========================================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for world-writable dirs

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
    export MANROFFOPT="-c"

    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# Quality-of-life ls aliases (overridden below when nls exists)
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'


# =========================================================
# COMMAND-NOT-FOUND HANDLER (Debian/Kali only — harmless elsewhere)
# =========================================================
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi


# =========================================================
# TOOLING: Bun, Homebrew, Atuin
# Each tool is loaded only if actually installed — safe to
# share across machines.
# =========================================================

# --- Bun ---
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# --- Homebrew (macOS default path OR Linuxbrew) ---
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"          # macOS (Apple Silicon)
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"             # macOS (Intel)
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"  # Linuxbrew
fi

# --- Atuin (shell history sync/search) ---
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"

## Oh-my-posh themes (optional)
# eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/powerlevel10k_lean.omp.json)"


# =========================================================
# OH MY ZSH
# =========================================================
export ZSH="$HOME/.oh-my-zsh"

# Theme to load. "random" picks a random theme each startup.
# To see which one loaded, run: echo $RANDOM_THEME
ZSH_THEME="candy"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Commented OMZ toggles (see http://github.com/ohmyzsh/ohmyzsh/wiki)
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# zstyle ':omz:update' mode auto      # auto update without asking
# zstyle ':omz:update' frequency 13
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# HIST_STAMPS="mm/dd/yyyy"

# Plugins (see $ZSH/plugins/ or $ZSH_CUSTOM/plugins/)
plugins=(git globalias)

source "$ZSH/oh-my-zsh.sh"


# =========================================================
# SPLIT MODULES (rarely changed — loaded after OMZ)
# =========================================================
ZSH_CONFIG_DIR="${0:A:h}"
source "$ZSH_CONFIG_DIR/completion.zsh"
source "$ZSH_CONFIG_DIR/highlighting.zsh"
unset ZSH_CONFIG_DIR


# =========================================================
# ALIASES & FUNCTIONS
# Defined last so they override anything from OMZ.
# =========================================================
eval "$(zoxide init zsh)"

alias e='z'
alias v='nvim'
alias ls='nls --group-directories-first'
alias ll='nls -lg --group-directories-first'
alias x='exit'

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

function yazi() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

fem() {
  local emulator
  local emulators

  emulators=$(
    flutter emulators |
      awk -F'•' '
        /^Id[[:space:]]/ { next }
        /^[[:space:]]*$/ { next }
        /To run an emulator/ { exit }
        /•/ {
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1)
          print $1
        }
      '
  ) || return

  emulator=$(
    printf '%s\n' "$emulators" |
      fzf \
        --prompt='Emulator > ' \
        --height=40% \
        --layout=reverse \
        --border
  ) || return

  flutter emulators --launch "$emulator"
}

litterbox() {
  local file result

  file=$(
    fd \
      --type f \
      --hidden \
      --follow \
      --exclude .git |
      fzf \
        --prompt='File > ' \
        --border-label=' Upload to Litterbox ' \
        --height=40% \
        --layout=reverse \
        --border
  ) || return

  echo -e "Selected file: \e[1;32m${file}\e[0m"

  result=$(
    curl --silent \
      -F "reqtype=fileupload" \
      -F "time=72h" \
      -F "fileToUpload=@${file}" \
      https://litterbox.catbox.moe/resources/internals/api.php
  )

  # Remove trailing '%' if present
  result="${result%\%}"

  echo "URL: ${result}"

  case "$OSTYPE" in
    linux*)
      if command -v wl-copy >/dev/null 2>&1; then
        printf "%s" "$result" | wl-copy
      elif command -v xclip >/dev/null 2>&1; then
        printf "%s" "$result" | xclip -selection clipboard
      elif command -v xsel >/dev/null 2>&1; then
        printf "%s" "$result" | xsel --clipboard --input
      else
        echo "No clipboard utility found."
      fi
      ;;
    darwin*)
      printf "%s" "$result" | pbcopy
      ;;
    msys*|cygwin*|win32*)
      printf "%s" "$result" | clip
      ;;
    *)
      echo "Unknown OS — cannot copy automatically."
      ;;
  esac

  echo "Copied to clipboard."
}
