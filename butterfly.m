%% Butterfly Function does the 2 point FFT of the inputs
% Note: (All the lines are written by author himself,the standard formulae are taken from references)

function [output1,output2]= butterfly(input1,input2)
output1=input1+input2;
output2=input1-input2;
end