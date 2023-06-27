function title {
  setopt localoptions nopromptsubst
  print -Pn "\e]2;${1:q}\a" # set title name
}

# Runs before showing the prompt
function title-precmd {
  title "%~"
}

# Runs before executing the command
function title-preexec {
  emulate -L zsh
  setopt extended_glob

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")

  title "%~  %100>...>${2:gs/%/%%}%<<"
}

autoload -Uz add-zsh-hook

add-zsh-hook precmd title-precmd
add-zsh-hook preexec title-preexec
