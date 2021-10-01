function fish_greeting
#    echo Logged in to (set_color blue;echo $hostname;set_color normal) at (set_color yellow;date +%T;set_color normal)
end

function gcfg
    /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME $argv
end

starship init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /data/miniconda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

