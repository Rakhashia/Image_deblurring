%% This function calls my_fft twice to generate 2D fft
% Note: (All lines are written by author himself,the standard formulae are taken from references)
function output=my_fft2(img,size_img_2_power)

size_img=size(img); %Size of image

%% Zero Padding
img_zero_pad=zeros(size_img_2_power); 
img_zero_pad(1:size_img(1),1:size_img(2))=img;
fft_row=zeros(size_img_2_power); 

for i=1:size_img_2_power(1) %Row wise fft
    fft_row(i,:)=my_fft(size_img_2_power(1),img_zero_pad(i,:));
end

output=zeros(size_img_2_power);

for i=1:size_img_2_power(2) %Column wise fft
    output(:,i)=my_fft(size_img_2_power(2),fft_row(:,i));
end

end