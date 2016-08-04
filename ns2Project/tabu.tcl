#create six nodes
 
for { set i 0} { $i < $opt(nodes) } {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) color black

	if { $opt(topotype) != "Random" } { 
 	    $node_($i) random-motion 0

	} else {
		$node_($i) start
	}
}

