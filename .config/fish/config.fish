function fish_greeting
    echo Logged in to (set_color blue;echo $hostname;set_color normal) at (set_color yellow;date +%T;set_color normal)
end

function gcfg
    /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME $argv
end

function pygr --wraps=egrep\ -rn\ --include\ \\\*.py --description 'grep recursively in python files'
  egrep -rn --include \*.py $argv;
end

function apt-up --description 'apt update + upgrade'
  sudo apt update && sudo apt upgrade
end
function apt-upd --description 'apt update'
  sudo apt update
end
function apt-upg --description 'apt upgrade'
  sudo apt upgrade
end
function apt-in --description 'apt install'
  sudo apt install $argv
end
function apt-rm --description 'apt remove'
  sudo apt remove $argv
end

function .. --description 'go up 1 level in directory'
  cd ..
end
function .1 --description 'go up 1 level in directory'
  cd ..
end
function .2 --description 'go up 2 levels in directory'
  cd ../..
end
function .3 --description 'go up 3 levels in directory'
  cd ../../..
end
function .4 --description 'go up 4 levels in directory'
  cd ../../../..
end


starship init fish | source
zoxide init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/coutinho/miniconda/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

set PATH $HOME/.local/bin $PATH
