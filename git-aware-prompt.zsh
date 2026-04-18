# git-aware-prompt.zsh

setopt PROMPT_SUBST

# Define colors

txtcyn="$(tput setaf 6 2>/dev/null || echo '\033[0;36m')"  # Cyan
txtred="$(tput setaf 1 2>/dev/null || echo '\033[0;31m')"  # Red
txtrst="$(tput sgr0 2>/dev/null || echo '\033[0m')"        # Reset

precmd() {
  PROMPT='%n@%m %1~$(git_branch) %# '
}

git_branch() {
  local branch dirty

  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    new_repo_branch

    return
  fi

  if ! branch=$(git symbolic-ref --short HEAD 2>/dev/null); then
    branch="detached"
  fi

  if ! git diff --quiet --ignore-submodules -- || \
     ! git diff --cached --quiet --ignore-submodules -- || \
     [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    dirty=1
  else
    dirty=0
  fi

  print_git_branch "$branch" "$dirty"
}

new_repo_branch() {
  local branch dirty

  branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  if [[ -n $(git diff --cached --name-only 2>/dev/null) ]] || \
     [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    dirty=1
  else
    dirty=0
  fi

  print_git_branch "${branch}:init" "$dirty"
}

print_git_branch() {
  local branch="$1"
  local dirty="$2"

  local c_cyn="%{${txtcyn}%}"
  local c_red="%{${txtred}%}"
  local c_rst="%{${txtrst}%}"

  if [[ "$dirty" -eq 1 ]]; then
    echo " ${c_cyn}(${branch})${c_red}*${c_rst}"
  else
    echo " ${c_cyn}(${branch})${c_rst}"
  fi
}
