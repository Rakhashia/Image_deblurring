%% This function computes the IDFT (2D) 
% Note: (All lines are written by author himself,the standard formulae are taken from references)

function img_ifft=my_idft2(img)

rows=size(img,1); %number of rows
cols=size(img,2); %number of columns
i=0:1:rows-1; 
j=0:1:cols-1;
ifft_mat_row=exp(1i*2*pi*(i'*i)/rows); %Twiddle factor matrix for rows
ifft_mat_col=exp(1i*2*pi*(j'*j)/cols); %Twiddle factor matrix for columns
img_ifft=ifft_mat_row*img*ifft_mat_col; 
img_ifft=img_ifft/(rows*cols);          %IDFT of an image
end