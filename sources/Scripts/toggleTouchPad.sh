#! /bin/bash

#	Getting Touchpad Id
touchpadId=\
$(xinput -list | grep Touchpad | sed "s/.*\(id=[0-9]\+\).*/\1/" | sed "s/id=//")
#	Getting Touchpad State
touchpadState=\
$(xinput list-props 21 | grep "Device Enabled" | sed "s/.*\([0-1]\).*/\1/")
if [[ $touchpadState -eq 1 ]]; then
	xinput disable $touchpadId
else
	xinput enable $touchpadId
fi
