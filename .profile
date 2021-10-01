echo "Loading .profile..."

. "$HOME/.cargo/env"

### PATH
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f ~/.bashrc ]; then
    .  ~/.bashrc;
fi
