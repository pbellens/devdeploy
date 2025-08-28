# https://jeroenjanssens.com/navigate/

export MARKPATH=$HOME/.marks
function j { 
    cd -P "$MARKPATH/$1" 2>/dev/null
    if [ $? -eq 0 ]; then 
        if [ ! -z ${TMUX+x} ]; then
            tmux rename-window -t${TMUX_PANE} "$1"
        fi
    else
         echo "No such mark: $1"
    fi
}
function m { 
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark { 
    rm -i "$MARKPATH/$1"
}
function marks {
    ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark
