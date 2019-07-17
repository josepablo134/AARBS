#! /bin/bash

#	List all running machines
function listVBoxMachines(){
	#	Query to virtual box manager
	VBoxManage list runningvms -s |
	#	Clear query result
	sed "s/{[a-z0-9\-]\+}//g" |
	sed "s/\"//g"
}
#	Stop a given machine or machines
function stopVBoxMachine_dispatcher(){
	for i in $*; do
		VBoxManage controlvm $i poweroff
		#VBoxManage startvm $i --type headless
	done
}
#	Stop all available machines
function stopAllVBoxMachines(){
	stopVBoxMachine_dispatcher $(listVBoxMachines)
}
#	Selection logic from dmenu output
function menuSelect(){
	if [[ -n $* ]]; then
		if [[ $1 == "All" ]]; then
			stopAllVBoxMachines
		else
			stopVBoxMachine_dispatcher $1
		fi
	fi
}

#	Entry point
menuSelect $( listVBoxMachines | sed "$ i All" | dmenu )

