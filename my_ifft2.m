%% This function calls my_ifft twice to generate 2D ifft
% Note: (All lines are written by author himself,the standard formulae are taken from references)
function output=my_ifft2(img,size_img_2_power)

size_img=size(img);%Size of image

%% Zero Padding
img_zero_pad=zeros(size_img_2_power);
img_zero_pad(1:size_img(1),1:size_img(2))=img;
ifft_row=zeros(size_img_2_power);

for i=1:size_img_2_power(1) %Row wise ifft
    ifft_row(i,:)=my_ifft(size_img_2_power(1),img_zero_pad(i,:));
end

output=zeros(size_img_2_power);
 
for i=1:size_img_2_power(2) %column wise ifft
    output(:,i)=my_ifft(size_img_2_power(2),ifft_row(:,i));
end
end