set f [open ./myvalues r]
gets $f opt(trs)
gets $f opt(topotype) 
gets $f opt(roupro) 
gets $f opt(nodes)
gets $f opt(ni)
gets $f opt(mc)
gets $f opt(qlen)
gets $f opt(type)
gets $f opt(packetsize)
gets $f opt(color)
set opt(dstcol) yellow
set opt(isnam) 1
set put "thrput"
set opt(throughput) "$opt(trs)$put"

#set opt(trs) basic
#initialization
#set opt(topotype) line
#set opt(roupro) AODV
#set opt(nodes) 6
#set opt(ni) 3
#set opt(mc) 5000
#set opt(qlen) 500
#set opt(type) cbr
#set opt(packetsize) 1000

#options



#traffic private


#compute
#set slottime        1
#是否开启nam,默认不开启

