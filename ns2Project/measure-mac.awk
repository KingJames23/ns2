BEGIN {
	init=0;
	i=0;
	recv=0;
	send=0;
}

{
action=$1;     #the event

time=$2;      #the time that event happened
node_nb=$3;
node_nb=substr(node_nb,2,1);
trace_type=$4;
pkt_type=$7;
pkt_size=$8;


if(action=="r"&&trace_type=="MAC"&&(pkt_type=="cbr"||pkt_type=="tcp")) 
  {
#printf("action=%s  ",action);
#printf("time=%f  ",time);
#printf("node_nb=%s  ",node_nb);
#printf("trace_type=%s  ",trace_type);
#printf("pkt_type=%s  ",pkt_type);
#printf("pkt_size=%d\n",pkt_size);
        
        pkt_byte_sum[i+1]=pkt_byte_sum[i]+(pkt_size-20);
	
	if(init==0)
       {
	 start_time=time;
	 init=1;
       }
       end_time[i]=time;
       i=i+1;
	recv++;
  }
else if(action=="s"&&trace_type=="MAC"&&(pkt_type=="cbr"||pkt_type=="tcp")) 
  {
	send++;
 }

}

END {	
        printf("i=%d\n",i);
        #printf("pkt_byte_sum[i]=%d\n",pkt_byte_sum[i]);
	#printf("%.2f\t%.2f\n",end_time[0],0);
	
	for(j=1;j<i;j++)
	{ #printf("pkt_byte_sum[j]=%d\n",pkt_byte_sum[j]);
	  th=pkt_byte_sum[j]*8/((end_time[j]-start_time)*1000000);
	 # printf("%.2f\t%.2f\n",end_time[j],th);
	}
	#printf("%.2f\t%.2f\n",end_time[i-1],0);
	#printf("start_time=%.2f\n",start_time);
	#printf("pkt_byte_sum[j]=%d\n",pkt_byte_sum[j]);
	printf("send=%d recv=%d\n",send,recv);
	printf("throughput=%.2f\n",(recv*8*1000)/(1000000.00*(end_time[i-1]-20)));
}
