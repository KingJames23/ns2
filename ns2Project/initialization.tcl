
#########initialization
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         $opt(qlen)                 ;# max packet in ifq
set val(nn)             $opt(nodes)                ;# number of mobilenodes
set val(ni)             $opt(ni)                   ;#max number of interfaces
set val(rp)             $opt(roupro)               ;# routing protocol
set val(x)              2000            ;#the range of topology   
set val(y)              2000            ;#the range of topology   

Mac/802_11 set SlotTime_          0.000020        ;# 20us
Mac/802_11 set SIFS_              0.000010        ;# 10us
Mac/802_11 set PreambleLength_    144            ;# 144 bit
Mac/802_11 set PLCPHeaderLength_  48              ;# 48 bits
Mac/802_11 set PLCPDataRate_      1.0e6           ;# 1Mbps
Mac/802_11 set dataRate_          2Mb          ;#Rate for data frames
Mac/802_11 set basicRate_         1Mb         ;#Rate for Control frames

set val(capacity)    143000000.00			;#load

#turn RTS/CTS on: ON = 0, OFF = 3000
#Mac/802_11 set RTSThreshold_ 3000

#frequency is 2.4 GHz
Phy/WirelessPhy set freq_ 2.472e+9         
#Data Rate
Phy/WirelessPhy set bandwidth_ 11Mb         

