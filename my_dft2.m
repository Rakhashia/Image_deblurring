%% This function computes the DFT (2D) 
% Note: (All lines are written by author himself,the standard formulae are taken from references)
function img_fft=my_dft2(img,size_img_with_zero_pad)

size_img=size(img); %size of an image

%% Zero Padding
img_zero_pad=zeros(size_img_with_zero_pad); %Zero padding 
img_zero_pad(1:size_img(1),1:size_img(2))=img;

rows=size(img_zero_pad,1); %number of rows
cols=size(img_zero_pad,2); %number of columns
i=0:1:rows-1; 
j=0:1:cols-1;
fft_mat_row=exp(-1i*2*pi*(i'*i)/rows); %Twiddle factor matrix for rows
fft_mat_col=exp(-1i*2*pi*(j'*j)/cols); %Twiddle factor matrix for columns
img_fft=(fft_mat_row*img_zero_pad*fft_mat_col); %DFT of an image
end