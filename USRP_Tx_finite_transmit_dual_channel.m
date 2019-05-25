%USRP_Tx_finite_transmit_dual_channel.m
%Collect a finite collection of samples from USRP and then quit

%DECLARE VARIABLES
%==========================================================================


%SCRIPT MAIN
%==========================================================================
disp('Starting finite streaming process (ctrl-c to terminate loop)...')

%Next go through loop and send data through the Tx USRP object.  
cnt=1;
while cnt<N_loop+1
    
    radio_tx(x_tx_data);    %Send message frames over to USRP	
    cnt = cnt+1;
end

