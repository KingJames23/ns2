# =======================================================================
# usage: awk -v step=<timestep> -v delayfile=<yourDelayFile> -v dropfile=<yourDropRatiofile> -f analys.awk  <yoursoure>
# eg: awk -v step=5.0  -v delayfile=aodv-delay.txt -v dropfile=aodv-drop.txt -f analys.awk aodv.tr
# =======================================================================

BEGIN {
	highest_packet_id = 0;
}

$0 {
	if($7 == "cbr") {
		action = $1;
		time = $2;
		layer = $4;
		packet_id = $6; 
		flag[packet_id]=1;

		#current node
		crtlgth = length($3);
		crtlgth -= 2;
		crt_node_id = substr($3,2,crtlgth); 
		
		#source node
		srclgth = index($14, ":");
		srclgth -= 2;
		src_node_id = substr($14,2,srclgth);
		
		#destination node
		dstlgth = index($15, ":");
		dstlgth -= 1;
		dst_node_id = substr($15,1,dstlgth);

				
		if ( packet_id > highest_packet_id )
			highest_packet_id = packet_id;
		
		if ( start_time[packet_id] == 0 )  start_time[packet_id] = time;
	   
		if ( layer == "AGT" && crt_node_id == dst_node_id && action == "r" ) {
			end_time[packet_id] = time;

		}
		else {
			end_time[packet_id] = -1;

		}
	}
}

END { 
	base = step;
	total_delay = 0.0;
	num_packets = 0;
	last_packet_id = 0;
	num_packettotal = 0;
	for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {				  
		starttime = start_time[packet_id]; 
		endtime = end_time[packet_id];
		if ( flag[packet_id]==1 ) 
		num_packettotal ++;
		if ( endtime!=-1 && starttime < endtime ) {
			num_packets ++;
			if ( starttime > base && num_packettotal!=0 ) {
				if(num_packets) 	printf "%f %f\n", base, total_delay/num_packets >> delayfile;
					else			printf "%f %f\n", base, 0 >> delayfile; 	
				printf "%f %f\n", base, (num_packettotal-num_packets)/num_packettotal >> dropfile;
				base += step;
				total_delay = 0.0;
				num_packets = 0;
				num_packettotal = 0;
				last_packet_id = packet_id;
			}
			packet_duration = endtime - starttime;
			printf "#%f %f %d\n", starttime, packet_duration,packet_id >> delayfile;
			total_delay += packet_duration;
			
		}
	} 	
}

   
   
   
