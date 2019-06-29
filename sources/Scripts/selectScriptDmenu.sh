#! /bin/bash
bash -c $HOME/Scripts/$(cat $HOME/Scripts/list.txt | dmenu )
#echo $HOME/Scripts/$(cat $HOME/Scripts/list.txt | dmenu )

