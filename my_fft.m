%% This function calculates the FFT of the input with size 'size_input'
% Note: (All lines are written by author himself,the standard formulae are taken from references)
function [fft_output]=my_fft(size_input,input)

k=1:1:size_input; 
twiddle=exp(-1i*2*pi*(k-1)/size_input);%Define twiddle factor
loops=log2(size_input); %Number of loops for FFT computation
bit_reversed=bitrevorder(k); %Reverse the bit order
A_bitreversed=input(bit_reversed); % Input arranged according to bit reversed order
stage_prev=A_bitreversed;%Store the value of previous stage. Initially the input
fft_output=zeros(size(input)); %Initialise the fft output as zero matrix
for i=1:loops %Number of stages
    temp_1=1; %Define two temp variables
    temp_2=1;
    count=0; %Count
    for j=1:size_input/2  %Number of FFT calculations per stage
        [fft_output(temp_1),fft_output(temp_1+2^(i-1))]=...
butterfly(stage_prev(temp_1),twiddle((size_input/2^i)*count+1)*stage_prev(temp_1+2^(i-1))); %Using butterfly function
        count=count+1; %Increment the count
        if(count~=2^(i-1)) 
            temp_1=temp_1+1;
        else
            if(i==loops)
                temp_1=1;
            else
                temp_1=temp_2+2^i;
            end
            temp_2=temp_1;
            count=0;
        end
    end
    stage_prev=fft_output; %Store previous stage outputs
end
end