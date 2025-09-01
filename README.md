# git-aware-prompt-zsh

A zsh compatible version of git-aware-prompt

I've used [git-aware-prompt](https://github.com/jimeh/git-aware-prompt) at this point for over a decade. Now that Apple has switched to zsh I needed to have a zsh compatible "version."

## How-to

Add the following to your `.zprofile` then `source .zprofile`:

```zsh
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

    if [[ -n $is_detached ]]; then
      # Detached HEAD

      if [[ $dirty -eq 1 ]]; then
        echo " ${txtcyn}(${branch} *)${txtrst}"
      else
        echo " ${txtcyn}(${branch})${txtrst}"
      fi
    else
      # Normal branch

      if [[ $dirty -eq 1 ]]; then
        echo " ${txtcyn}(${branch})${txtred}*${txtrst}"
      else
        echo " ${txtcyn}(${branch})${txtrst}"
      fi
    fi
  fi
}

precmd() {
  PROMPT='%n@%m %1~$(git_branch) %# '
}
```
