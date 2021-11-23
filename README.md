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
git
git-gui
codium
syncthing
docker.io
gimp
fish
htop
emacs
n
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
cargo install starship alacritty zoxide exa
```

### Switch shell to fish

Edit `/etc/passwd` and replace your user `/bin/bash` with `/usr/bin/fish`

