# dotfiles

My personal dotfiles

## Installation

```bash
cd ~
git clone git@github.com:tiagocoutinho/dotfiles
git init --bare $HOME/dotfiles
git config --local status.showUntrackedFiles no
```

## Additional configuration

### emacs

Probably icons won't show up well so do
```
M-x all-the-icons-install-fonts
```

## Setup new Linux (debian based)

One day may become an ansible playbook...

### VS Codium repo

```bash
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg 

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
```

### Syncthing repo

```bash
sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
```

### Packages

```
openssh-server
sshfs
git
git-gui
codium
syncthing
docker.io
docker-compose
gimp
fish
htop
emacs
nvim
vlc
tree
libc-dev            # starship
libssl-dev          # starship
cmake               # alacritty
g++                 # alacritty
libfontconfig1-dev  # alacritty
libxcb-shape0-dev   # alacritty
libxcb-render0-dev  # alacritty
libxcb-xfixes0-dev  # alacritty
```

### Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Miniconda

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
sh ./Miniconda3-latest-Linux-x86_64.sh
```

### Local packages

```bash
# prompt niceness
cargo install starship

# alternative terminal
cargo install alacritty

# alternatives to cd, ls
cargo install zoxide exa

# monitoring tools (alternative to top)
cargo install bb ytop bottom battop

# git helpers:
cargo install delta
```

### Switch shell to fish

Edit `/etc/passwd` and replace your user `/bin/bash` with `/usr/bin/fish`

### Docker

Edit `/etc/docker/daemon.json`

```json
{
  "features": {"buildkit" : true},
  "data-root": "/home/docker/data",
  "insecure-registries" : []
}
```

* The first line enables BuildKit which allows for faster builds
* The second line relocates docker storage in case you don't have enough space
  in the default */var/lib/docker/*
* Add any additional docker registries

You will need to restart docker service after these changes. Do it with

```bash
sudo systemctl restart docker.service
```

#### Docker compose

This repo contains a *.config/fish/fish_variables* file which already includes
COMPOSE_DOCKER_CLI_BUILD so you only need to do the instructions below if you
don't use it.

To enable BuildKit on docker compose do:

If using fish do:

```fish
set -Ux COMPOSE_DOCKER_CLI_BUILD 1
```

otherwise set it in `~/.bashrc` for example.
