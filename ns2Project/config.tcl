#############create Simulator object
set ns_ [new Simulator]
$ns_ color 0 $opt(color)
###create trace for wireless scenario
#$ns_ use-newtrace
set tracefd [open $opt(tr) w]

Agent/OLSR set use_mac_    true
#$ns_ use-newtrace
$ns_ trace-all $tracefd

if {$opt(isnam) == 1 } {
set namtrace [open $opt(nam) w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
}

##
##topo
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
 set god_ [create-god $opt(nodes)]

#移动节点的数目作为参数传递给 GOD,用于创建一个存储拓扑连接信息的矩阵

##create wireless channels

for {set i 0} {$i< $val(ni) } {incr i} {
     set chan_($i) [new $val(chan)]
     }
##


##########node-config
$ns_ node-config -adhocRouting $val(rp) \
	-llType $val(ll) \
	-macType $val(mac) \
	-ifqType $val(ifq) \
	-ifqLen $val(ifqlen) \
	-antType $val(ant) \
	-propType $val(prop) \
	-phyType $val(netif) \
	-channel $chan_(0) \
	-topoInstance $topo \
	-agentTrace ON \
	-routerTrace ON \
	-macTrace ON \
	-movementTrace OFF \
	-ifNum $val(ni)

