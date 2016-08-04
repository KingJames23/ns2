Simulator instproc initial_node_pos {nodep size} {
	$self instvar addressType_
	$self instvar energyModel_ 

	if [info exists energyModel_] {  
		set nodeColor "green"
	} else {
		#set nodeColor "black"
                set tempcolor [$nodep set attr_(COLOR)]
                if {$tempcolor == "green"} {
                    puts "Green is reserved for energy model , you may not set your node green"
                    set tempcolor "black"
                }
                #puts "Node color is set to $tempcolor"
                set nodeColor $tempcolor
	}
	if { [info exists addressType_] && $addressType_ == "hierarchical" } {
		# Hierarchical addressing
		$self puts-nam-config "n -t * -a [$nodep set address_] \
-s [$nodep id] -x [$nodep set X_] -y [$nodep set Y_] -Z [$nodep set Z_] \
-z $size -v circle -c $nodeColor"
	} else { 
		# Flat addressing
		$self puts-nam-config "n -t * -s [$nodep id] \
-x [$nodep set X_] -y [$nodep set Y_] -Z [$nodep set Z_] -z $size \
-v circle -c $nodeColor"
	}
}
