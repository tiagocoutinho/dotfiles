function fish_greeting
#    echo Logged in to (set_color blue;echo $hostname;set_color normal) at (set_color yellow;date +%T;set_color normal)
end

function gcfg
    /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME $argv
end

function pygr --wraps=egrep\ -rn\ --include\ \\\*.py --description 'grep recursively in python files'
  egrep -rn --include \*.py $argv;
end

starship init fish | source
zoxide init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/coutinho/miniconda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

set PATH $HOME/.local/bin $PATH
