echo "Loading .bashrc..."

# git config for my dotfiles
alias gcfg='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

eval "$(starship init bash)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/data/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/data/miniconda/etc/profile.d/conda.sh" ]; then
        . "/data/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/data/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

