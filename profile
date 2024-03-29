# /etc/profile

# === 
# functions
# ====


recurseFolderPath(){
	# :h for name only
	# :t for name with extension
	for file in $1/* ; do
		if [[ -d $file ]]
		then
			recurseFolderPath $file
		else
			if [[ -f $file ]]
			then
				PATH=$PATH:$folder
			fi
		fi
	done
}

# Set our umask
umask 022

# Append "$1" to $PATH when not already in.
# This function API is accessible to scripts in /etc/profile.d
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# Append our default paths
append_path '/usr/local/sbin'
append_path '/usr/local/bin'
append_path '/usr/bin'

# Force PATH to be environment
export PATH

# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Unload our profile API functions
unset -f append_path

# Source global bash config, when interactive but not posix or sh mode
if test "$BASH" &&\
   test "$PS1" &&\
   test -z "$POSIXLY_CORRECT" &&\
   test "${0#-}" != sh &&\
   test -r /etc/bash.bashrc
then
	. /etc/bash.bashrc
fi

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH
#export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$HOME/.config/zsh"

# :h for name only
# :t for name with extension
for folder in ~/.local/bin/* ; do
	if [[ -d $folder ]]
	then
		PATH=$PATH:$folder
	fi
done

PATH=$PATH:~/.local/bin
recurseFolderPath ~/.local/bin

PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig
EDITOR="nvim"
echo "Startx?? (y,n)"
read doit 
if [[ $doit == "" || $doit == "y" ]] ;
then
		startx $HOME/.config/X11/.xinitrc
fi
