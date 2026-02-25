# Environment Setup

Ansible-based automated setup for a personal Ubuntu workstation. Installs and configures shell, editor, Node.js/Bun toolchain, Docker, PHP, and applications.

## Playbooks

| Playbook | File                    | Description                                                  |
|----------|-------------------------|--------------------------------------------------------------|
| `base`   | `playbooks/base.yml`    | Core setup: shell, editors, git, node, docker, php, apps     |
| `full`   | `playbooks/full.yml`    | Everything in base + i3, Kitty terminal, wallpapers          |

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

> The `personal-projects.yml` task (currently commented out in the playbooks) clones private repositories and requires this SSH key to be working before it can be enabled.

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

**Step 3.** Run a playbook:

```bash
./play         # runs base playbook (default), prompts for git name/email
./play base    # same as above
./play full    # full setup including i3, Kitty, wallpapers
```

When running interactively, the playbook will prompt you for your git name and email. You can leave them blank to skip git identity setup.

To pre-configure git identity without prompts, copy `config.yml.example` to `config.yml`, fill in your details, and pass it via `-e`:

```bash
cp config.yml.example config.yml
# edit config.yml with your git name and email
./play base -e @config.yml
```

Or pass values directly on the command line:

```bash
./play base -e "git_name='Your Name' git_email=you@example.com"
```

If neither is provided, the git identity tasks are skipped.

Or run only specific parts using tags (see [Tags](#tags) below):

```bash
./play base --tags "node,zsh"
./play full --tags "wm"
```

### Option 2 — Run inside Docker (for testing)

**Step 1.** Build the image (automatically extracts SSH keys from `~/ssh-backup.tar.gz` if present):

```bash
./build-dockers
```

**Step 2.** Run a playbook:

```bash
docker run --rm new-computer                          # base (default)
docker run --rm -e PLAYBOOK=full new-computer         # full setup
```

Run only specific parts using tags:

```bash
docker run --rm -e TAGS="--tags zsh,node" new-computer
docker run --rm -e PLAYBOOK=full -e TAGS="--tags wm" new-computer
```

The `install` tag is the broadest option and runs everything marked as a standard install:

```bash
docker run --rm -e TAGS="--tags install" new-computer
```

To explore the container interactively:

```bash
docker run --rm -it --entrypoint bash new-computer
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
