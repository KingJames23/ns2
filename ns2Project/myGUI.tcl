#﻿wm title . "NS2环境中OLSR协议的研究及模拟"
grid [frame .f] -column 0 -row 0 -sticky nwes
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

#命名仿真文件
grid [label .f.laType -text "仿真文件命名" ] -column 1 -row 1 -sticky nwes
grid [entry .f.fileName -width 7 -textvariable fileName ] -column 2 -row 1 -sticky nwes

#选择拓扑类型
grid [label .f.latopotype -text "拓扑类型"] -column 1 -row 2 -sticky nwes
grid [radiobutton .f.line -text Line -variable topotype -value Line] -column 2 -row 2 -sticky w
grid [radiobutton .f.matrix -text Matrix -variable topotype -value Matrix] -column 3 -row 2 -sticky w
grid [radiobutton .f.random -text Random -variable topotype -value Random] -column 4 -row 2 -sticky w

#选择协议
grid [label .f.laRout -text "协    议"] -column 1 -row 3 -sticky nwes
grid [radiobutton .f.olsr -text OLSR -variable roupro -value OLSR] -column 2 -row 3 -sticky w
grid [radiobutton .f.aodv -text AODV -variable roupro -value AODV] -column 3 -row 3 -sticky w
grid [radiobutton .f.dsr -text DSR -variable roupro -value DSR] -column 4 -row 3 -sticky w

#输入节点数量
grid [label .f.laNodeNum -text "节点数量"] -column 1 -row 4 -sticky nwes
grid [entry .f.nodeNum -width 7 -textvariable nodeNum ] -column 2 -row 4 -sticky w

#输入产生流量节点数量
grid [label .f.laNodeNum2 -text "产生流量节点数量"] -column 3 -row 4 -sticky nwes
grid [entry .f.lanodeNum -width 7 -textvariable lanodeNum ] -column 4 -row 4 -sticky w

#生成节点总数
grid [label .f.laNodeNum3 -text "发送数据包总数"] -column 1 -row 5 -sticky nwes
grid [entry .f.allnode -width 7 -textvariable allnode ] -column 2 -row 5 -sticky w

#设置网络接口队列大小
grid [label .f.laqlen -text "接口队列大小"] -column 3 -row 5 -sticky nwes
grid [entry .f.qlen -width 7 -textvariable qlen ] -column 4 -row 5 -sticky w


#选择流量类型
grid [label .f.laTcpUdp -text "Cbr流量类型"] -column 1 -row 6 -sticky nwes
#grid [radiobutton .f.cbr -text Cbr -variable flowType -value cbr] -column 2 -row 6 -sticky w
grid [radiobutton .f.tcp -text Tcp -variable flowType -value tcp] -column 2 -row 6 -sticky w
grid [radiobutton .f.udp -text Udp -variable flowType -value udp] -column 3 -row 6 -sticky w

# 设置发送包大小
grid [label .f.lapacketsize -text "packetsize"] -column 1 -row 7 -sticky nwes
grid [entry .f.packetsize -width 7 -textvariable packetsize ] -column 2 -row 7 -sticky w
grid [label .f.danwei -text "字节"] -column 3 -row 7 -sticky w
#是否启用nam
grid [label .f.lanam -text "运行nam"] -column 1 -row 8 -sticky nwes
grid [radiobutton .f.isnam -text isnam -variable isnam -value isnam] -column 2 -row 8 -sticky nwes
grid [radiobutton .f.nonam -text nonam -variable isnam -value nonam] -column 3 -row 8 -sticky nwes
#选择连接的颜色
grid [label .f.laColor -text "链接颜色"] -column 1 -row 9 -sticky nwes
grid [radiobutton .f.red -text red -variable color -value red] -column 2 -row 9 -sticky w
grid [radiobutton .f.blue -text blue -variable color -value blue] -column 3 -row 9 -sticky w
grid [radiobutton .f.yellow -text yellow -variable color -value yellow] -column 4 -row 9 -sticky w

#查看结果按钮

grid [button .f.save -text "保存设置" -command prWrite] -column 1 -row 10 -sticky nwes
grid [button .f.run -text "运行程序" -command prRun] -column 2 -row 10 -sticky nwes
grid [button .f.throughPutR -text "吞吐量查看" -command prThroughPutR] -column 3 -row 10 -sticky nwes
#grid [button .f.throughPutP -text "吞吐量绘图" -command prThroughPutP] -column 4 -row 7 -sticky nwes
#grid [button .f.delay -text "时延" -command prDelay] -column 3 -row 7 -sticky nwes

#
#随机生成两个节点产生流量
#
set ::nodeNum 6
set ::lanodeNum 3
set ::allnode 10000
set ::qlen 500
set ::packetsize 1000
set ::topotype Line
set ::roupro OLSR
set ::color red

proc prWrite {} {
#将图形界面中选择的数据写入到一个中间文件中
#在tcl主程序中读取这个文件中的数据，进行设置

     set f [open ./myvalues w]
     puts $f $::fileName
     puts $f $::topotype
     puts $f $::roupro
     puts $f $::nodeNum
     puts $f $::lanodeNum
     puts $f $::allnode
     puts $f $::qlen
     puts $f $::flowType
     puts $f $::packetsize
     puts $f $::color
     close $f
}

#数据分析
proc prRun {} {
	exec sh runall.sh & exit 0
#}
proc prThroughPutR {} {
	exec sh readresult.sh & exit 0
}
#proc prThroughPutP {} {
#	exec gnuplot -p -e "set xlabel '时间(s)';set ylabel '吞吐量(kb)'; plot 'throughput_OLSR' with lines,'throughput_AODV' with #lines,'throughput_DSR' with lines"
#}
#proc prDelay {} {
#	exec gnuplot -p -e "set xlabel '时间(s)';set ylabel '延迟(s)'; plot 'delay_OLSR' with lines,'delay_AODV' with lines,'delay_DSR' with #lines"		gawk –f throughput.awk olsr_wireless.tr > throughput_***
#}

