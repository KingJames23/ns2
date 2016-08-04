#打开argv文件，读取其中的图形界面中选择的数据
#对相应的参数作设置
set f [open ./argv r]
gets $f nodeNum
gets $f routPro
gets $f layout
gets $f col
gets $f wLan
gets $f tcpUdp
gets $f traffic
gets $f rand(0)
gets $f rand(1)
#puts $nodeNum


#更改节点颜色函数
#更改与mobilenode.cc源文件
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
# ======================================================================
# Define options
# ======================================================================
set opt(chan)           Channel/WirelessChannel  ;# channel type
set opt(prop)           Propagation/TwoRayGround ;# radio-propagation model
set opt(netif)          Phy/WirelessPhy          ;# network interface type
set opt(mac)            Mac/802_11               ;# MAC type
set opt(ifq)            Queue/DropTail/PriQueue  ;# interface queue type
set opt(ll)             LL                       ;# link layer type
set opt(ant)            Antenna/OmniAntenna      ;# antenna model
set opt(ifqlen)         50                       ;# max packet in ifq
set opt(nn)             $nodeNum                 ;# number of mobilenodes
set opt(adhocRouting)   $routPro                 ;# routing protocol

set opt(cp)             ""                       ;# connection pattern file
set opt(sc)             ""                       ;# node movement file. 

set opt(x)              1250                     ;# x coordinate of topology
set opt(y)              1250                     ;# y coordinate of topology
set opt(seed)           0.0                      ;# seed for random number gen.
set opt(cbr-stop)	[expr $traffic/10+10]
set opt(stop)           100                      ;# time to stop simulation

set opt(cbr-start)      10.0
# ============================================================================

Mac/802_11 set CWMin_		 31
Mac/802_11 set CWMax_		 1023
Mac/802_11 set dataRate_	1Mb	;#802.11 data trans_mission rate
Mac/802_11 set basicRate_	1Mb	;#802.11 basic trans_mission rate
Mac/802_11 set newchipset_ true



#
#检查随机种子
#
if {$opt(seed) > 0} {
    puts "Seeding Random number generator with $opt(seed)\n"
    ns-random $opt(seed)
}

#
#创建模拟器实例
#
set ns_ [new Simulator]

#
#设置颜色
#
$ns_ color 0 $col


#
# control OLSR behaviour from this script -
# commented lines are not needed because
# those are default values
#
Agent/OLSR set use_mac_    true
#Agent/OLSR set debug_      false
#Agent/OLSR set willingness 3
#Agent/OLSR set hello_ival_ 2
#Agent/OLSR set tc_ival_    5

#
# open traces
#
set tracefd  [open olsr_wireless.tr w]
set namtrace [open olsr_wireless.nam w]
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

#
# create topography object
#
set topo [new Topography]

#
# define topology
#
$topo load_flatgrid $opt(x) $opt(y)

#
# create God
#
set god_ [create-god $opt(nn)]

#
# configure mobile nodes
#

set chan_1_ [new $opt(chan)]

$ns_ node-config -adhocRouting $opt(adhocRouting) \
                 -llType $opt(ll) \
                 -macType $opt(mac) \
                 -ifqType $opt(ifq) \
                 -ifqLen $opt(ifqlen) \
                 -antType $opt(ant) \
                 -propType $opt(prop) \
                 -phyType $opt(netif) \
                 -channel $chan_1_ \
                 -topoInstance $topo \
                 -wiredRouting OFF \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace OFF
#
#生成节点
#
for {set i 0} {$i < $opt(nn)} {incr i} {
    set aaa [expr $i+100]
    #puts $aaa
    #puts "------------------------"
    set node_($aaa) [$ns_ node]
    $node_($aaa) color black
#设置节点随机移动
    $node_($aaa) random-motion $layout
    if {$layout == 1} {
            $node_($aaa) start
    }
}

#
# 生成每个节点的位置，方阵类型
#
if {$layout ==0} {
set i 100
set num [expr ceil([expr sqrt($nodeNum)])]
for {set j 0} {$j < $num } {incr j} {
    for {set k 0} {$k < $num && $i<$nodeNum+100} {incr k} {
            $node_($i) set X_ [expr 100.0+$j*250]
            $node_($i) set Y_ [expr 100.0+$k*250]
            $node_($i) set Z_ 0.0
                set i [expr $i+1]
}        
}
}

#
#生成随机数函数
#
#proc random {nodeNum} {
#    return [expr {int(rand() * $nodeNum)}]
#}

#
#随机生成两个节点产生流量
#
#for {set i 0} {$i<2} {incr i} {
#    set bbb [random $nodeNum]
#    set rand($i) [expr $bbb+100]
#
#防止生成的两个节点是同一个节点
#
#    for {set j 0} {$j<$i} {incr j} {
#        if {$rand($j) == $rand($i) } {
#            set i [expr $i-1]
#        }  
#    }
#}

#
# 建立udp连接，产生流量
#

#
#使产生流量的节点随机移动
#
set mvNode(0) $rand(0)
set mvNode(1) $rand(1)
for {set t 0} {$t<1} {incr t} {
    set i $rand($t)
#选择TCP流量还是UDP流量
if {$tcpUdp == 0} {
	set tcp [new Agent/TCP/Newreno]
	$ns_ attach-agent $node_($i) $tcp
	$node_($i) color $col
	#set mvNode(0) $i
        set ddd $rand(1)
	$node_($ddd) color $col
	set sink [new Agent/TCPSink/DelAck]
	$ns_ attach-agent $node_($ddd) $sink
	$ns_ connect $tcp $sink
	$tcp set fid_ 0
	set ftp [new Application/FTP]
	$ftp attach-agent $tcp
	$ftp set type_ FTP
	$ftp set packetSize_ 1000
	$ftp set rate_ 1mb
	$ftp set interval_ 0.1
	$ns_ at $opt(cbr-start) "$ftp start"
	$ns_ at $opt(cbr-stop) "$ftp stop"
} else {
    set udp [new Agent/UDP]
    set null [new Agent/Null]
    $ns_ attach-agent $node_($i) $udp
#设置节点颜色
    $node_($i) color $col
    #set mvNode(0) $i
    set ddd $rand(1)
    $ns_ attach-agent $node_($ddd) $null
#设置节点颜色
    $node_($ddd) color $col
    #set mvNode(1) $ddd
    $ns_ connect $udp $null
#
#设置udp连接的颜色为红色
#
    $udp set fid_ 0
    set cbr [new Application/Traffic/CBR]
    $cbr set packetSize_ 1000
    $cbr set rate_ 1mb
    $cbr set interval_ 0.1
    $cbr attach-agent $udp
    $ns_ at $opt(cbr-start) "$cbr start"
    $ns_ at $opt(cbr-stop) "$cbr stop"
    }
    
}
    if {$layout == 0} {
        for {set i 0} {$i < $opt(nn)} {incr i} {
            for {set j [expr $i+1]} {$j < $opt(nn)} {incr j} {
                if {$i != $j} {
                   $god_ set-dist $i $j 1
                }
            }
        }
        $ns_ at 11.0 "$node_($mvNode(0)) setdest 800.0 800.0 20"
        $ns_ at 11.0 "$node_($mvNode(1)) setdest 100.0 100.0 20"
        $ns_ at 25.0 "$node_($mvNode(0)) setdest 100.0 800.0 20"
        $ns_ at 25.0 "$node_($mvNode(1)) setdest 800.0 100.0 20"
    }


#
# print (in the trace file) routing table and other
# internal data structures on a per-node basis
#
#$ns_ at 10.0 "[$node_(0) agent 255] print_rtable"
#$ns_ at 15.0 "[$node_(0) agent 255] print_linkset"
#$ns_ at 20.0 "[$node_(0) agent 255] print_nbset"
#$ns_ at 25.0 "[$node_(0) agent 255] print_nb2hopset"
#$ns_ at 30.0 "[$node_(0) agent 255] print_mprset"
#$ns_ at 35.0 "[$node_(0) agent 255] print_mprselset"
#$ns_ at 40.0 "[$node_(0) agent 255] print_topologyset"

#
# source connection-pattern and node-movement scripts
#
if { $opt(cp) == "" } {
    #puts "*** NOTE: no connection pattern specified."
    set opt(cp) "none"
} else {
    #puts "Loading connection pattern..."
    source $opt(cp)
}
if { $opt(sc) == "" } {
    #puts "*** NOTE: no scenario file specified."
    set opt(sc) "none"
} else {
    #puts "Loading scenario file..."
    source $opt(sc)
    #puts "Load complete..."
}

#
# 设置节点初始大小
#
for {set i 0} {$i < $opt(nn)} {incr i} {
    set aaa [expr $i+100]
    $ns_ initial_node_pos $node_($aaa) 50
}     

#
# tell all nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    set aaa [expr $i+100]
    $ns_ at $opt(stop).0 "$node_($aaa) reset";
}

$ns_ at $opt(stop).0002 " $ns_ halt"
$ns_ at $opt(stop).0001 "stop"

proc stop {} {
    global ns_ tracefd namtrace
    $ns_ flush-trace
    close $tracefd
    close $namtrace
    exec gawk -f drop.awk olsr_wireless.tr > DROP &
    exec nam olsr_wireless.nam &
    exit 0
}

#
# 开始模拟
#

$ns_ run
