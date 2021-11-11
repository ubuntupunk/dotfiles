# +-------+
# | ssh   |
# +-------+
alias sexthera="ssh sexthera@ams-node7.websitehostserver.net"
alias pactivate="source jupyterenv/bin/activate"
alias uber="ssh afro@cetus.uberspace.de"
alias soundreload="pulseaudio -k && sudo alsa force-reload"
alias locate="plocate"
alias youtubes="ytfzf"

# +------+
# | lynx |
# +------+

alias lynx='lynx -vikeys -accept_all_cookies'

# +------+
# | grep |
# +------+

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gh='history | grep'

# +--------+
# | System |
# +--------+

alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'

alias bigf='find / -xdev -type f -size +500M'  # display "big" files > 500M
alias count='find . -type f | wc -l'
alias cputemp='sensors | grep Core'

alias update='sudo apt-get update && sudo apt-get upgrade'
alias acs="apt-cache search"

# +---------+
# | netstat |
# +---------+

alias port="netstat -tulpn | grep"

alias youtube-dl="youtube-dl -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4"


#Git
alias pull='git pull origin master'
alias add='git add --all'
alias push='git push --all'

#Audio
alias moc="mocp ~/Music"


#some config from pywal for dmenu
# Import the colors.
. "${HOME}/.cache/wal/colors.sh"

# Create the alias.
alias dmen='dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"'

#=============+
# | FUNCTIONS |
#=============+

gitcombo() {
   add
   message=""
   for arg in "$@"
   do
      message += "$arg"
      message += " "
   done
   git commit -m "$message"
   push
}

#Change directory & list files
cl() {
   cd $1
   ls -la
}

