#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# modified commands
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'

# new commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet --inet6'
alias pg='ps -Af | grep $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)

# privileged access
if [ $UID -ne 0 ]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
    alias update='sudo pacman -Syu'
    alias netcfg='sudo netcfg'
    alias nano='sudo nano'
fi

# ls
alias ls='ls -hF --color=auto --group-directories-first'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l --group-directories-first'
alias la='ll -A --group-directories-first'
alias lx='ll -BX --group-directories-first'                   # sort by extension
alias lz='ll -rS --group-directories-first'                   # sort by size
alias lt='ll -rt --group-directories-first'                   # sort by date
alias lm='la | more'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# pacman aliases (if applicable, replace 'pacman' with 'yaourt'/'pacaur'/whatever)
alias pac="yaourt -S"        # default action     - install one or more packages
alias pacu="yaourt -Syua"     # '[u]pdate'         - upgrade all packages to their newest version
alias pacs="yaourt -Ss"      # '[s]earch'         - search for a package using one or more keywords
alias paci="yaourt -Si"      # '[i]nfo'           - show information about a package
alias pacr="yaourt -R"       # '[r]emove'         - uninstall one or more packages
alias pacl="yaourt -Sl"      # '[l]ist'           - list all packages of a repository
alias pacll="yaourt -Qqm"    # '[l]ist [l]ocal'   - list all packages which were locally installed (e.g. AUR packages)
alias paclo="yaourt -Qdt"    # '[l]ist [o]rphans' - list all packages which are orphaned
alias paco="yaourt -Qo"      # '[o]wner'          - determine which package owns a given file
alias pacf="yaourt -Ql"      # '[f]iles'          - list all files installed by a given package
alias pacc="yaourt -Sc"      # '[c]lean cache'    - delete all not currently installed package files
alias pacm="makepkg -fci"    # '[m]ake'           - make package from PKGBUILD file in current directory
alias pacusr="yaourt -Qqet"  # '[usr] installed'  - end user install list

# Video Commands
#alias mplayer="mplayer $1 -softvol -softvol-max 300"
#alias futurama="mplayer -shuffle -playlist ~/Playlists/futurama.m3u"
#alias familyguy="mplayer -shuffle -playlist ~/Playlists/familyguy.m3u"
#alias simpsons="mplayer -shuffle -playlist ~/Playlists/simpsons.m3u"
#alias americandad="mplayer -shuffle -playlist ~/Playlists/americandad.m3u"
#alias bobsburgers="mplayer -softvol -softvol-max 300 -shuffle -playlist ~/Playlists/bobsburgers.m3u"

# Suspend
#alias suspend="su -c 'echo "mem" >/sys/power/state'"

# RDP Aserver
alias rdp="rdesktop -g 1024x768 -f -P -z -x b -r sound:off -u dragon840 aserver.hopto.org:3389"

# Check Mem Use
alias memfree="free -m -l"

# Autocomplete
complete -cf sudo
complete -cf man

# Screen capture at 1920x1080
alias screencap="ffmpeg -f x11grab -s 1920x1080 -r 15 -i :0 -vcodec libx264 -vpre normal -threads 0 ~/screencap.mp4"

# Play mounted iso
alias playiso="mplayer dvd:// -dvd-device /mnt/disk/"

# Mount iso to /mnt/disk/
alias mountiso="_mountiso"
function _mountiso()
{
sudo mount -t iso9660 -o ro,loop=/dev/loop0 $1 /mnt/disk/
}

# Mount a 1GB ramdisk in /mnt/tmp/
alias ramdisk="sudo mount -t ramfs -o nodev,nosuid,noexec,nodiratime,size=1024M none /mnt/tmp/"

# Test for dynamic text width
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Auto cd
shopt -s autocd

# Start nfs and mount nfs server
#alias nfsmount='sudo systemctl start nfsd.service rpc-idmapd.service && sudo mount 192.168.2.22:/mnt /mnt/server_root'
#alias nfsumount='sudo systemctl stop nfsd.service rpc-idmapd.service && sudo umount /mnt/server_root'

# simplified systemd command, for instance "sudo systemctl stop xxx" - > "0.stop xxx"
if ! systemd-notify --booted;
then  # for not systemd
    0.start() {
        sudo rc.d start $@
    }

    0.restart() {
        sudo rc.d restart $@
    }

    0.stop() {
        sudo rc.d stop $@
    }
else
# start systemd service
    0.start() {
        sudo systemctl start $@
    }
# restart systemd service
    0.restart() {
        sudo systemctl restart $@
    }
# stop systemd service
    0.stop() {
        sudo systemctl stop $@
    }
# enable systemd service
    0.enable() {
        sudo systemctl enable $@
    }
# disable a systemd service
    0.disable() {
        sudo systemctl disable $@
    }
# show the status of a service
    0.status() {
        systemctl status $@
    }
# reload a service configuration
    0.reload() {
        sudo systemctl reload $@
    }
# list all running service
    0.list() {
        systemctl
    }
# list all failed service
    0.failed () {
        systemctl --failed
    }
# list all systemd available unit files
    0.list-files() {
        systemctl list-unit-files
    }
# check the log
    0.log() {
        sudo journalctl
    }
# show wants
    0.wants() {
        systemctl show -p "Wants" $1.target
    }
# analyze the system
    0.analyze() {
        systemd-analyze $@
    }
fi


#PS1='[\u@\h \W]\$ '
#PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\] '
red="\[\e[0;33m\]"
yellow="\[\e[0;31m\]"

if [ `id -u` -eq "0" ]; then
    root="${yellow}"
else
    root="${red}"
fi
PS1="\[\e[0;37m\]┌─[${root}\u\[\e[0;37m\]][\[\e[0;96m\]\h\[\e[0;37m\]][\[\e[0;32m\]\w\[\e[0;37m\]]\n\[\e[0;37m\]└──╼ \[\e[0m\]"
PS2="╾──╼"
