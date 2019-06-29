#! /bin/bash
feh --bg-fill $HOME/Pictures/wallpapers/$( cat $HOME/Pictures/wallpapers/list.txt | dmenu )
