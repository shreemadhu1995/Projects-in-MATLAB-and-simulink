%USRP_Tx_streaming_transmit_dual_channel.m
%Collect a finite collection of samples from USRP and then quit

%SCRIPT MAIN
%==========================================================================
disp('Starting finite streaming process (ctrl-c to terminate loop)...')

%Next send data through the Tx USRP object in an indefinite loop  
while(1)
    
    radio_tx(x_tx_data);    %Send message frames over to USRP
    
end

