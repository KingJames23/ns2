set slottime        1
set opt(vi)	$opt(nodes)
proc create-tcp-connection {src dst} { 
    global ns_ cbr_cnt opt node_  j tcp_ slottime start1 start stop1
    #set stime [$rng uniform 0 5]
    set rng [new RNG]
    $rng seed 0
    set r2 [new RandomVariable/Uniform]
    $r2 set min_ 0
    $r2 set max_ 0.9
    $r2 use-rng $rng
puts "_______rng____________"
    set y [$r2 value]

    set start1 [expr $start+$y]
    #set start1 $start
 
    ##puts "#n# $src connecting to $dst at time $stime+$opt(startime)\n"
puts "_______tcp____________"

    set tcp_($cbr_cnt) [new Agent/TCP]
	$tcp_($cbr_cnt)  set fid_ 1
   	$ns_ attach-agent $node_($src) $tcp_($cbr_cnt)
puts "_______ftp____________"
    set ftp_($cbr_cnt)  [new Application/FTP]
	$ftp_($cbr_cnt)  attach-agent $tcp_($cbr_cnt) 
	$ftp_($cbr_cnt)  set type_ FTP
	$ftp_($cbr_cnt)  set packetSize_ $opt(packetsize)
	$ftp_($cbr_cnt)  set rate_ 1mb
	$ftp_($cbr_cnt)  set interval_ 0.1
puts "_______sink____________"
    set sink_($cbr_cnt)  [new Agent/TCPSink]
    	$ns_ attach-agent $node_($dst) $sink_($cbr_cnt)  
	$ns_ connect $tcp_($cbr_cnt) $sink_($cbr_cnt)
#       $ns_ connect $ftp_($cbr_cnt) $sink_($cbr_cnt)

     puts "start1=$start1"
     puts "stop1=$stop1" 
     puts "cbr_cnt=$cbr_cnt"

     $ns_ at $start1 "$ftp_($cbr_cnt) start"
     $ns_ at $stop1 "$ftp_($cbr_cnt) stop"
     #cbr_cnt is the total number of traffic
     set cbr_cnt [expr $cbr_cnt + 1]

#__________________________________
#__________________________________
 }
#代理是否相同
proc create-udp-connection {src dst} { 
    global rng ns_ cbr_cnt opt node_  j cbr_ slottime start1 start stop1
    #set stime [$rng uniform 0 5]
    set rng [new RNG]
    $rng seed 0
    set r2 [new RandomVariable/Uniform]
    $r2 set min_ 0
    $r2 set max_ 0.9
    $r2 use-rng $rng

    set y [$r2 value]
puts "y = $y ***"
    set start1 [expr $start+$y]
  
 
    ##puts "#n# $src connecting to $dst at time $stime+$opt(startime)\n"
    set udp_($cbr_cnt) [new Agent/UDP]
    $ns_ attach-agent $node_($src) $udp_($cbr_cnt)
    # Create a CBR traffic source and attach it to udp0
    set cbr_($cbr_cnt) [new Application/Traffic/CBR]
 
    $cbr_($cbr_cnt) set packetSize_ $opt(pktsize)
    $cbr_($cbr_cnt) set interval_ $opt(interval)
    $cbr_($cbr_cnt) attach-agent $udp_($cbr_cnt)

    #Create a Null agent (a traffic sink) and attach it to node n1
    set null_($cbr_cnt) [new Agent/Null]
    $ns_ attach-agent $node_($dst) $null_($cbr_cnt)
     
     #Connect the traffic source with the traffic sink
     $ns_ connect $udp_($cbr_cnt) $null_($cbr_cnt)
     puts "start1=$start1"
     puts "stop1=$stop1" 
     puts "cbr_cnt=$cbr_cnt"
     $ns_ at $start1 "$cbr_($cbr_cnt) start"
     $ns_ at $stop1 "$cbr_($cbr_cnt) stop"
     #cbr_cnt is the total number of traffic
     incr cbr_cnt

 }
set rng [new RNG]
$rng seed $opt(seed)

set r1 [new RandomVariable/Uniform]
$r1 set min_ 0
$r1 set max_ 100
$r1 use-rng $rng


#cbr_cnt is the total number of traffic
set cbr_cnt 0
set start1 0
set stop1  0

set start1 [expr $opt(startime)]
set stop1  [expr $slottime+$start1]
set start $start1
set stop $stop1

set sum 0
#j: the seconds that is running
set j 0 
#generate two different random nodes $src and $dst
#every two traffics run for 1 slottime
#when $stop1<= $opt(endtime), continue generate new traffic
puts "ns starts simulator "
set count 0
while { $stop<= $opt(endtime) } { 
	set load1 0
	set number 0
	set loadpercent 0
	while { $loadpercent < $opt(percent)} {
   		set src 0
   		set dst 0
   		#load

   		while ($src==$dst) {
    		set x [$r1 value]
     		set src [expr [expr int($x)] % $opt(vi)]
     		set x [$r1 value]
     		set dst [expr [expr int($x)] % $opt(vi)]
     		if {$src!=$dst} { 
		$node_($src) color $opt(color)
		$node_($dst) color $opt(dstcol)
         		puts "$src  $dst"  
			set count [expr $count + 1]   
         		break 
      			}
   		}	;##while($src==$dst)
  
		puts "______________________"
	          #add the load calculation

	 		switch -glob -- $opt(topotype) {
				L* {
				if { $src < $dst } {
						set temps $src
						set src $dst	
						set dst $temps
						}
			set load1 [expr [expr [expr $src - $dst]*2]+$load1]
					}
				M* {

					if { $src < $dst } {
						set temps $src
						set src $dst	
						set dst $temps
						}
				set load1 [expr [expr [expr $src - $dst]*1]+$load1]
					}		
				R* {
					if { $src < $dst } {
						set temps $src
						set src $dst	
						set dst $temps
						}
				set load1 [expr [expr [expr $src - $dst]*2]+$load1]
					}	
				default {
			puts "the topogy is not found!"
					 }
  		 	}
	  		incr number
			puts "count=$count"
          		puts "load1=$load1"
	  		set loadpercent [expr $load1*8*10000/$val(capacity)]
	  		puts [format "loadpercent=%.3f" $loadpercent]
   		if { $opt(type)=="tcp"} {	 		
          		create-tcp-connection $src $dst
      		} else {
          		create-udp-connection $src $dst
     			 }
		$node_($src) color black
		$node_($dst) color black
     		if { $cbr_cnt>=$opt(mc) } {
         		break
     			}
   	}
	set start  [expr $stop]
	set stop1  [expr $slottime+$start]
	set stop $stop1
	puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}
  


