%% This function calculates the IFFT
% Note: (All lines are written by author himself,the standard formulae are taken from references)
function [ifft_output]=my_ifft(size_input,input)

k=1:1:size_input;
twiddle=exp(1i*2*pi*(k-1)/size_input);%Define twiddle factor
loops=log2(size_input);%Number of loops for IFFT computation
bit_reversed=bitrevorder(k); %Reverse the bit order
A_bitreversed=input(bit_reversed); % Input arranged according to bit reversed order
stage_prev=A_bitreversed; %Store the value of previous stage. Initially the input
ifft_output=zeros(size(input)); %Initialise the fft output as zero matrix
for i=1:loops %Number of stages
    first_coord=1; %Define two temp variables
    second_coord=1;
    count=0; %Count
    
    for j=1:size_input/2 %Number of FFT calculations per stage
        [ifft_output(first_coord),ifft_output(first_coord+2^(i-1))]=butterfly(stage_prev(first_coord),twiddle((size_input/2^i)*count+1)*stage_prev(first_coord+2^(i-1))); %Using butterfly function
        count=count+1; %Increment the count
        if(count~=2^(i-1))
            first_coord=first_coord+1;
        else
            if(i==loops)
                first_coord=1;
            else
                first_coord=second_coord+2^i;
            end
            second_coord=first_coord;
            count=0;
        end
    end
    stage_prev=ifft_output; %Store previous stage outputs
end
ifft_output=ifft_output/size_input; %The constant factor of (1/MN) multiplied with the output
end