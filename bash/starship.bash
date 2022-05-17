function set_win_title(){
  echo -ne "\033]0; $(basename "$PWD") \007"
}
starship_precmd_user_func="set_win_title"
export STARSHIP_CONFIG=~/dotfiles/bash/starship.toml
eval "$(starship init bash)"
