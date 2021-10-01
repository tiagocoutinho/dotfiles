# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/tcoutinho/miniconda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

source ~/.asdf/asdf.fish

function fish_greeting
#    echo Logged in to (set_color blue;echo $hostname;set_color normal) at (set_color yellow;date +%T;set_color normal) 
end

starship init fish | source
