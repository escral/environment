# Environment Setup

Ansible-based automated setup for a personal Ubuntu workstation. Installs and configures shell, editor, window manager, Node.js/Bun toolchain, and applications.

## Prerequisites

- Ubuntu (20.04 or later)
- `sudo` access
- An SSH key pair placed at `.ssh/id_rsa` / `.ssh/id_rsa.pub` relative to this repo (required for the SSH task)

### Generating an SSH key

If you don't have one yet:

```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

This creates `~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub` by default. Copy them into the `.ssh/` directory inside this repo:

```bash
cp ~/.ssh/id_ed25519 .ssh/id_rsa
cp ~/.ssh/id_ed25519.pub .ssh/id_rsa.pub
```

Then add the public key to your GitHub account: **Settings → SSH and GPG keys → New SSH key**, and paste the contents of `.ssh/id_rsa.pub`.

> The `personal-projects.yml` task (currently commented out in `local.yml`) clones private repositories and requires this SSH key to be working before it can be enabled.

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

| Tag            | What it runs                          |
|----------------|---------------------------------------|
| `install`      | Everything marked as a standard install |
| `core`         | Core system packages                  |
| `zsh`          | ZSH + Oh My Zsh                       |
| `node`         | nvm, Node.js v22                      |
| `bun`          | Bun runtime                           |
| `neovim`       | Neovim + Packer                       |
| `vim`          | Vim                                   |
| `dotfiles`     | Dotfiles clone + stow                 |
| `ssh`          | SSH key setup                         |
| `wm`           | Window manager (i3)                   |
| `terminal`     | Kitty terminal                        |
| `apps`         | VSCode, Chrome                        |
| `git-personal` | Git global identity                   |
| `productivity` | fzf + fzf-marks                       |

## Cleanup

`clean-env` is a helper script to uninstall the packages installed by this playbook (for testing or resetting):

```bash
./clean-env
```
