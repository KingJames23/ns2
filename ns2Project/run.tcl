##reset-time
set val(nn) $opt(nodes)
for {set i 0} {$i<$val(nn)} {incr i} {
    $ns_ at $opt(endtime) "$node_($i) reset"
    $ns_ initial_node_pos $node_($i) 50
}
puts "______++++++++++++++0_________"
##

##stop proc
proc stop {} { 
puts "______++++++++++++++1_________"
    global ns_ tracefd opt
puts "______+++++++++++++2_________"
    $ns_ flush-trace
    close $tracefd
puts "______++++++++++++++3_________"
if {$opt(isnam) == 1 } {
puts "______++++++++++++++4_________"
    global ns_ namtrace
    $ns_ flush-trace
  #  exec gawk -f measure-mac.awk olsr_wireless.tr > $opt(throughput)
    close $namtrace
}
    exit 0
}
##
$ns_ at $opt(endtime) "stop"
$ns_ at $opt(endtime) "puts\"NS is exiting?-\"; $ns_ halt"
$ns_ run
