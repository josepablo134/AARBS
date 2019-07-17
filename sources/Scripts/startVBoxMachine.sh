#! /bin/bash

#	List all available machines
function listVBoxMachines(){
	#	Query to virtual box manager
	VBoxManage list vms -s |
	#	Clear query result
	sed "s/{[a-z0-9\-]\+}//g" |
	sed "s/\"//g"
}
#	Run a given machine or machines
function runVBoxMachine_dispatcher(){
	for i in $*; do
		VBoxManage startvm $i --type headless
	done
}
#	Run all available machines
function runAllVBoxMachines(){
	runVBoxMachine_dispatcher $(listVBoxMachines)
}
#	Selection logic from dmenu output
function menuSelect(){
	if [[ -n $* ]]; then
		if [[ $1 == "All" ]]; then
			runAllVBoxMachines
		else
			runVBoxMachine_dispatcher $1
		fi
	fi
}

#	Entry point
menuSelect $( listVBoxMachines | sed "$ i All" | dmenu )

