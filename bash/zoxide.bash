# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
  \command cygpath -w "$(\builtin pwd -P)"
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
  # shellcheck disable=SC2164
  \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
__zoxide_oldpwd="$(__zoxide_pwd)"

function __zoxide_hook() {
  \builtin local -r retval="$?"
  \builtin local pwd_tmp
  pwd_tmp="$(__zoxide_pwd)"
  if [[ ${__zoxide_oldpwd} != "${pwd_tmp}" ]]; then
    __zoxide_oldpwd="${pwd_tmp}"
    \command zoxide add -- "${__zoxide_oldpwd}"
  fi
  return "${retval}"
}

# Initialize hook.
if [[ ${PROMPT_COMMAND:=} != *'__zoxide_hook'* ]]; then
  PROMPT_COMMAND="__zoxide_hook;${PROMPT_COMMAND#;}"
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
  # shellcheck disable=SC2199
  if [[ $# -eq 0 ]]; then
    __zoxide_cd ~
  elif [[ $# -eq 1 && $1 == '-' ]]; then
    __zoxide_cd "${OLDPWD}"
  elif [[ $# -eq 1 && -d $1 ]]; then
    __zoxide_cd "$1"
  elif [[ ${@: -1} == "${__zoxide_z_prefix}"?* ]]; then
    # shellcheck disable=SC2124
    \builtin local result="${@: -1}"
    __zoxide_cd "${result:${#__zoxide_z_prefix}}"
  else
    \builtin local result
    # shellcheck disable=SC2312
    result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
      __zoxide_cd "${result}"
  fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
  \builtin local result
  result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin unalias z &>/dev/null || \builtin true
function z() {
  __zoxide_z "$@"
}

\builtin unalias zi &>/dev/null || \builtin true
function zi() {
  __zoxide_zi "$@"
}

# eval "$(zoxide init bash)"
