%% This function gives the butterworth LPF filter frequency response
% Note: The author has himself written the code by taking reference from :
% https://stackoverflow.com/questions/20932229/how-to-apply-butterwoth-filter-on-an-image

function output=butterworth_lpf(size,cutoff,order)

output=zeros(size); %Initialise output as zero matrix

for i = 1:size(1) %Rows
    for j=1:size(2) %Columns
        d=sqrt((i-size(1)/2)^2+(j-size(2)/2)^2); %d in formula
        output(i,j)= 1/(1 + (d/cutoff)^(2*order));
    end
end
end