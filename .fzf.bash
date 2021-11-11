# Setup fzf
# ---------
if [[ ! "$PATH" == */home/afropunk/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/afropunk/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/afropunk/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/afropunk/.fzf/shell/key-bindings.bash"
