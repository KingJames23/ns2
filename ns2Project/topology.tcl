
set tempx 100

switch -exact -- $opt(topotype) {
	Line {
		for {set i 0} { $i < $opt(nodes)} {incr i} {
			$node_($i) set X_ [ expr $i*250 + $tempx ]
			$node_($i) set Y_ 300
			$node_($i) set Z_ 0.0
puts "_____________Line_____________________________"
puts "_____________Line_____________________________"
puts "_____________Line_____________________________"
puts "_____________Line_____________________________"
			}
		 for {set i 0} {$i < $opt(nodes)} {incr i} {
     	  	  for {set j [expr $i+1]} {$j < $opt(nodes)} {incr j} {
      	 	     if {$i != $j} {
       		      $god_ set-dist $i $j 2
	   			}
	        	   }
			}
		}
	Matrix {
puts "_____________Matrix_____________________________"
puts "_____________Matrix_____________________________"
puts "_____________Matrix_____________________________"
puts "_____________Matrix_____________________________"
puts "_____________Matrix_____________________________"
		set i 0
		set num [expr ceil([expr sqrt($opt(nodes))])]
		for {set j 0} {$j < $num } {incr j} {
   			 for {set k 0} {$k < $num && $i<$opt(nodes)} {incr k} {
           			 $node_($i) set X_ [expr $tempx+$j*250]
           			 $node_($i) set Y_ [expr $tempx+$k*250]
           			 $node_($i) set Z_ 0.0
              			 set i [expr $i+1]
					}        
				}
		 for {set i 0} {$i < $opt(nodes)} {incr i} {
     	  	  for {set j [expr $i+1]} {$j < $opt(nodes)} {incr j} {
      	 	     if {$i != $j} {
       		      $god_ set-dist $i $j 2
	   			}
	        	   }
			}
		}

	Random {
puts "_____________Random_____________________________"
puts "_____________Random_____________________________"
puts "_____________Random_____________________________"
puts "_____________Random_____________________________"
puts "_____________Random_____________________________"
		}
	default {
		puts "______*************_______"
		puts "do not exsit this topolgy"
		puts "______*************_______"
		}
}

