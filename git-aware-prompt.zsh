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
  local branch

  if ! is_git_repo; then
    return
  fi

  if is_new_repo; then
    new_repo_branch

    return
  fi

  if ! branch=$(git symbolic-ref --short HEAD 2>/dev/null); then
    branch="detached"
  fi

  print_git_branch "$branch" is_git_dirty
}

new_repo_branch() {
  local branch

  branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  print_git_branch "${branch}:init" is_new_repo_dirty
}

# Helper functions

is_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null
}

is_new_repo() {
  ! git rev-parse --verify HEAD >/dev/null 2>&1
}

print_git_branch() {
  local branch="$1"
  local dirty_fn="$2"

  local c_cyn="%{${txtcyn}%}"
  local c_red="%{${txtred}%}"
  local c_rst="%{${txtrst}%}"

  if $dirty_fn; then
    echo " ${c_cyn}(${branch})${c_red}*${c_rst}"
  else
    echo " ${c_cyn}(${branch})${c_rst}"
  fi
}

is_git_dirty() {
  if ! git diff --quiet --ignore-submodules -- || \
     ! git diff --cached --quiet --ignore-submodules -- || \
     [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    return 0
  else
    return 1
  fi
}

is_new_repo_dirty() {
  if [[ -n $(git diff --cached --name-only 2>/dev/null) ]] || \
     [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
    return 0
  else
    return 1
  fi
}