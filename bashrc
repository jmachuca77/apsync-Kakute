####### New Prompt ###################

parse_git_branch() {

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'

}

if [ "$color_prompt" = yes ]; then
    export PS1=\[\033[32m\]\u@\e[32m\H\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[\033[38;5;11m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\\n(\[\033[38;5;11m\]\$(parse_git_branch)\[\033[38;5;15m\]) \[\033[32m\]\$\[$(tput sgr0)\] 
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


PS1=${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n (\[\033[38;5;11m\]\$(parse_git_branch)\[\033[38;5;15m\]) 