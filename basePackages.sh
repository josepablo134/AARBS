#! /bin/sh
#	Write a message to stdout with color format
logger()
{
	COLOR='\033[0;34m' # Blue
	#\033[0;32m # Green
	NC='\033[0m' # No Color
	echo -e ${COLOR} $* ${NC}
}
#	Write a message with color format
cerr()
{
	RED='\033[0;31m'
	>&2 echo -e ${RED} $* ${NC}
}
#	Send a error message and exit
errorHandler()
{
	case $1 in
	1)
		cerr "This is the 1st error"
		;;
	2)
		cerr "This is de 2nd error"
		break
		;;
	*)
		cerr "Something went wrong"
		;;
  	esac
	exit -1
}
#	Verify file existance, reeplace file 1 with file 2
#	if the file does not exists, return 1
replace()
{
	# Move rotated logs to the archive
	if [ -f $1 ]; then
		logger "Replacing " $1 "with " $2
		#	Copy of security
		mv $1 $1"_old"
		#	Replace file
		cp $2 $1
		return 0
	else
		return 1
	fi
}
#	replace with sudo
sreplace()
{
	# Move rotated logs to the archive
	if [ -f $1 ]; then
		logger "Replacing " $1 "with " $2
		#	Copy of security
		sudo mv $1 $1"_old"
		#	Replace file
		sudo cp $2 $1
		return 0
	else
		return 1
	fi
}
BASEDIR=$(pwd)

logger "Installing base packages"
#	Basic tools
sudo pacman -Sy archlinux-keyring --noconfirm ||\
	cerr "Error installing archlinux-keyring"
sudo pacman-key --refresh-keys ||\
	cerr "Error refreshing keys"
sudo pacman -Syu vim ranger ntfs-3g linux-headers openssh --noconfirm ||\
	cerr "Error installing vim & ranger"
#	X11 tools
sudo pacman -S xorg xorg-xinit xterm --noconfirm ||\
	cerr "Error installing Xorg"
#	X11 environment
sudo pacman -S i3 dmenu --noconfirm ||\
	cerr "Error installing i3 DE"
sudo pacman -S xcompmgr acpilight surf tabbed feh ffmpeg ||\
	cerr "Error installing DE Tools"
#	Audio tools
sudo pacman -S alsa-lib alsa-plugins \
pulseaudio-alsa pavucontrol-qt --noconfirm ||\
	cerr "Error installing audio tools"
#	Devel tools
sudo pacman -S nodejs python3 terminator firefox git || \
	cerr "Error installing miscellaneous"

logger "Copying configuration files"
#	Replace with sudo
sreplace /etc/X11/xinit/xinitrc $BASEDIR/sources/xinitrc.txt ||\
	cerr "Error replacing X11"
#	Set keyboard lang
sudo cp $BASEDIR/sources/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
#	Set Bashrc
replace $HOME/.bashrc $BASEDIR/sources/bashrc.txt
cp $BASEDIR/sources/bash_personal.txt $HOME/.bash_personal
#	Set i3 Configuration
mkdir -p $HOME/.config/i3
cp $BASEDIR/sources/config.txt $HOME/.config/i3/config
#	Set vim configuration
cp $BASEDIR/sources/vimrc.txt $HOME/.vimrc
#	Copying personal scripts
mkdir -p $HOME/Scripts
cp $BASEDIR/sources/Scripts/* $HOME/Scripts/

mkdir -p $HOME/Dev/Git/Personal
mkdir -p $HOME/Documents/
mkdir -p $HOME/Downloads
mkdir -p $HOME/Pictures
