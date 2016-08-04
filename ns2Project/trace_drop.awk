#$：gwak –f drop trace > d


BEGIN {
         #程序初始化，设定变量记录传输以及被丢弃的包的数目
       fsDrops = 0;   #被丢弃的包的数目
       numfs0 = 0;   #0节点发送的CBR封包的数目
       numfs2 = 0;   #2节点接收的CBR封包的数目
}
{
       event = $1;
       time = $2;
       node_nb = $3;
       trace_type = $4;
       flag = $5;
       uid = $6
       pkt_type = $7;
       pkt_size = $8; 

       node_nb=substr(node_nb,2,1);

       #统计节点0发送的CBR封包
       if (node_nb==0 && event== "s" && trace_type== "MAC" && pkt_type== "cbr") 
              numfs0++;
       #统计节点2丢弃的CBR封包
       if (node_nb==2 && event== "r" && trace_type== "MAC" && pkt_type== "cbr") 
              numfs2++;
}

END {
       average=0;   #average用于记录丢包率
       fsDrops = numfs0-numfs2;    #丢包数目
       average=fsDrops/numfs0;     #丢包率
       printf("number of packets sent:%d lost_rate:%d\n", numfs0, average);  #打印发送封包数目和丢包率
}
