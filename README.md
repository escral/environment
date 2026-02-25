# Environment Setup

Ansible-based automated setup for a personal Ubuntu workstation. Installs and configures shell, editor, window manager, Node.js toolchain, and applications.

## Prerequisites

- Ubuntu (20.04 or later)
- `sudo` access
- An SSH private key at `.ssh/id_rsa` relative to this repo (required for the SSH task)

## Bootstrap

### Option 1 — Run directly on the machine

**Step 1.** Install Ansible:

```bash
./install
```

**Step 2.** Place your SSH key inside this repo directory before running:

```
.ssh/
  id_rsa
  id_rsa.pub
```

**Step 3.** Run the full playbook:

```bash
./play
```

Or run only specific parts using tags (see [Tags](#tags) below):

```bash
ansible-playbook local.yml --tags "node,zsh"
```

### Option 2 — Run inside Docker (for testing)

Build the image:

```bash
./build-dockers
```

Run with optional tags:

```bash
docker run --env TAGS="--tags install" new-computer
```

## Tags

Run subsets of tasks by passing `--tags`:

| Tag          | What it runs                          |
|--------------|---------------------------------------|
| `install`    | Everything marked as a standard install |
| `core`       | Core system packages                  |
| `zsh`        | ZSH + Oh My Zsh                       |
| `node`       | nvm, Node.js, npm                     |
| `neovim`     | Neovim + Packer                       |
| `vim`        | Vim                                   |
| `dotfiles`   | Dotfiles clone + stow                 |
| `ssh`        | SSH key setup                         |
| `wm`         | Window manager (i3)                   |
| `terminal`   | Kitty terminal                        |
| `apps`       | VSCode, Chrome                        |
| `git-personal` | Git global identity                 |
| `productivity` | fzf + fzf-marks                     |

## Cleanup

`clean-env` is a helper script to uninstall the packages installed by this playbook (for testing or resetting):

```bash
./clean-env
```
