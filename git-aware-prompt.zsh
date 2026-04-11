# git-aware-prompt.zsh

setopt PROMPT_SUBST

# Define colors

txtcyn="$(tput setaf 6 2>/dev/null || echo '\033[0;36m')"  # Cyan
txtred="$(tput setaf 1 2>/dev/null || echo '\033[0;31m')"  # Red
txtrst="$(tput sgr0 2>/dev/null || echo '\033[0m')"        # Reset

git_branch() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch dirty is_detached

    if ! branch=$(git symbolic-ref --short HEAD 2>/dev/null); then
      is_detached=1
      branch="detached *"
    fi

    # Determine if dirty

    if ! git diff --quiet --ignore-submodules -- || ! git diff --cached --quiet --ignore-submodules --; then
      dirty=1
    else
      dirty=0
    fi

    # Wrap color vars in %{ %} so zsh ignores them for cursor positioning

    local c_cyn="%{${txtcyn}%}"
    local c_red="%{${txtred}%}"
    local c_rst="%{${txtrst}%}"

    if [[ -n $is_detached ]]; then
      # Detached HEAD

      if [[ $dirty -eq 1 ]]; then
        echo " ${c_cyn}(${branch} *)${c_rst}"
      else
        echo " ${c_cyn}(${branch})${c_rst}"
      fi
    else
      # Normal branch

      if [[ $dirty -eq 1 ]]; then
        echo " ${c_cyn}(${branch})${c_red}*${c_rst}"
      else
        echo " ${c_cyn}(${branch})${c_rst}"
      fi
    fi
  fi
}

precmd() {
  PROMPT='%n@%m %1~$(git_branch) %# '
}
