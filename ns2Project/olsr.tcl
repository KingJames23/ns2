#﻿wm title . "NS2环境中OLSR协议的研究及模拟"
grid [frame .f] -column 0 -row 0 -sticky nwes
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

#选择网络类型
grid [label .f.laType -text "网络类型"] -column 1 -row 1 -sticky nwes
grid [radiobutton .f.lan -text 有线网络 -variable wLan -value 0] -column 2 -row 1 -sticky w
grid [radiobutton .f.wirelesslan -text 无线网络 -variable wLan -value 1] -column 3 -row 1 -sticky w

#选择协议
grid [label .f.laRout -text "协    议"] -column 1 -row 2 -sticky nwes
grid [radiobutton .f.olsr -text OLSR -variable rout -value OLSR] -column 2 -row 2 -sticky w
grid [radiobutton .f.aodv -text AODV -variable rout -value AODV] -column 3 -row 2 -sticky w
grid [radiobutton .f.dsr -text DSR -variable rout -value DSR] -column 4 -row 2 -sticky w

#输入节点数量
grid [label .f.laNodeNum -text "节点数量"] -column 1 -row 3 -sticky nwes
grid [entry .f.nodeNum -width 7 -textvariable nodeNum ] -column 2 -row 3 -sticky w

#选择节点布局
grid [label .f.laNodeLayout -text "节点布局"] -column 1 -row 4 -sticky nwes
grid [radiobutton .f.layRan -text 方阵 -variable layout -value 0] -column 2 -row 4 -sticky w
grid [radiobutton .f.layFang -text 随机 -variable layout -value 1] -column 3 -row 4 -sticky w

#选择连接的颜色
grid [label .f.laColor -text "链接颜色"] -column 1 -row 5 -sticky nwes
grid [radiobutton .f.red -text red -variable color -value red] -column 2 -row 5 -sticky w
grid [radiobutton .f.blue -text blue -variable color -value blue] -column 3 -row 5 -sticky w
grid [radiobutton .f.yellow -text yellow -variable color -value yellow] -column 4 -row 5 -sticky w

#选择连接方式
grid [label .f.laTcpUdp -text "连接方式"] -column 1 -row 6 -sticky nwes
grid [radiobutton .f.tcp -text Tcp -variable tcpUdp -value 0] -column 2 -row 6 -sticky w
grid [radiobutton .f.udp -text Udp -variable tcpUdp -value 1] -column 3 -row 6 -sticky w

#输入网络负荷
grid [label .f.laLiuLiang -text "网络负荷"] -column 1 -row 7 -sticky nwes
grid [entry .f.liuliang -width 7 -textvariable traffic ] -column 2 -row 7 -sticky w
grid [label .f.danwei -text "mb"] -column 3 -row 7 -sticky w

#查看结果按钮
grid [button .f.nam -text "运行nam" -command prNam] -column 1 -row 8 -sticky nwes
grid [button .f.drop -text "丢包率" -command prDrop] -column 4 -row 8 -sticky nwes
grid [button .f.throughPut -text "吞吐量" -command prThroughPut] -column 2 -row 8 -sticky nwes
grid [button .f.delay -text "时延" -command prDelay] -column 3 -row 8 -sticky nwes

#
#随机生成两个节点产生流量
#
set ::nodeNum 6

#运行nam
proc prNam {} {

#将图形界面中选择的数据写入到一个中间文件中
#在tcl主程序中读取这个文件中的数据，进行设置

  for {set i 0} {$i<2} {incr i} {
    set bbb [expr rand()]
    set bbb [expr {int($bbb*$::nodeNum)}]
    set rand($i) [expr $bbb+100]
   #
   #防止生成的两个节点是同一个节点
   #
    for {set j 0} {$j<$i} {incr j} {
        if {$rand($j) == $rand($i) } {
            set i [expr $i-1]
        }  
    }
  }
     set f [open ./argv w]
     puts $f $::nodeNum
     puts $f $::rout
     puts $f $::layout
     puts $f $::color
     puts $f $::wLan
     puts $f $::tcpUdp
     puts $f $::traffic
     puts $f $rand(0)
     puts $f $rand(1)
     close $f
     if {$::wLan==0} {
     exec ns olsr_line.tcl &
     exit 0
     } else {
     exec ns olsr_wireless.tcl &
     exit 0
     }
}

#数据分析
proc prDrop {} {
	exec cat drop_OLSR drop_AODV drop_DSR > /dev/tty
}
proc prThroughPut {} {
	exec gnuplot -p -e "set xlabel '时间(s)';set ylabel '吞吐量(kb)'; plot 'throughput_OLSR' with lines,'throughput_AODV' with lines,'throughput_DSR' with lines"
}
proc prDelay {} {
	exec gnuplot -p -e "set xlabel '时间(s)';set ylabel '延迟(s)'; plot 'delay_OLSR' with lines,'delay_AODV' with lines,'delay_DSR' with lines"
}

