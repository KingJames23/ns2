# 使用的是无线trace的旧格式
BEGIN {
     highest_packet_id = 0;
} 
{
   action = $1;
   time = $2;
   packet_id = $6;
   type = $7;
   
# 不考虑路由包，可以保证序号为0的cbr被统计到
   if ( type == "cbr" ) {
   
   if ( packet_id > highest_packet_id )
	 highest_packet_id = packet_id;
 
#记录封包的传送时间
   if ( start_time[packet_id] == 0 )  
	start_time[packet_id] = time;
 
#记录CBR 的接收时间
   if (  action != "D" ) {
      if ( action == "r" ) {
         end_time[packet_id] = time;
      }
   } else {
#把不符合条件的数据包的时间设为-1
      end_time[packet_id] = -1;
   }
}	
}						  
END {
#当资料列全部读取完后，开始计算有效封包的端点到端点延迟时间 
    for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
       start = start_time[packet_id];
       end = end_time[packet_id];
       packet_duration = end - start;
 
#只把接收时间大于传送时间的记录列出来
       if ( start < end ) printf("%f %f\n", start, packet_duration);
   }
}