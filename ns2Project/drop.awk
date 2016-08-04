
BEGIN {
#
    fsDrops = 0;
    numFs = 0;
}


{
    action = $1;
    time = $2;
    node_id = $3;
    trace_type = $4;
    packet_id = $6;
	pkt_type=$7;
 if (action=="s"&&trace_type=="MAC"&&pkt_type == "cbr")
      numFs++;

 if (action == "D"&&trace_type=="MAC"&&pkt_type == "cbr")
    fsDrops++;
 
}

END{  
         printf("共发送%d个包，丢失%d个包\n",numFs,fsDrops);
         printf("丢包率：%f\n",fsDrops/numFs);
}
