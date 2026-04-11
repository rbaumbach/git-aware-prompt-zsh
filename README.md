# git-aware-prompt-zsh

A simple, fast, git-aware prompt for zsh.

Shows:
- current branch
- dirty state

## Installation

Clone the repo:

```bash
git clone https://github.com/rbaumbach/git-aware-prompt-zsh.git ~/git-aware-prompt-zsh
```

Add this to your `~/.zprofile`:

```zsh
source "$HOME/git-aware-prompt-zsh/git-aware-prompt.zsh"
```

Restart your terminal or reload your shell:

```zsh
source ~/.zprofile
```

Note: You can clone this repo anywhere. Just update the path in your `~/.zprofile` accordingly.

## Example

Inside a git repo:

```zsh
arnold@t800 ~/ill-be-back (maestro) %
```

With changes:

```zsh
arnold@t800 ~/ill-be-back (maestro)* %
```

## Acknowledgements

Inspired by the original [git-aware-prompt](https://github.com/jimeh/git-aware-prompt).