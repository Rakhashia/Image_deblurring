%% This function does the fftshift/ifftshift 
% Note: (All lines are written by author himself,the standard formulae are taken from references)
function fftshifted_img=my_fftshift(img_fft)

size_fft=size(img_fft); %Size of image
fftshifted_img=zeros(size_fft); %Initialise the output image

%Swap the first and third quadrants, as well as second and fourth quadrants
fftshifted_img(1:size_fft(1)/2,1:size_fft(2)/2)=...
    img_fft(size_fft(1)/2+1:size_fft(1),size_fft(2)/2+1:size_fft(2)); 
fftshifted_img(size_fft(1)/2+1:size_fft(1),size_fft(2)/2+1:size_fft(2))=...
    img_fft(1:size_fft(1)/2,1:size_fft(2)/2);
fftshifted_img(size_fft(1)/2+1:size_fft(1),1:size_fft(2)/2)=...
    img_fft(1:size_fft(1)/2,size_fft(2)/2+1:size_fft(2));
fftshifted_img(1:size_fft(1)/2,size_fft(2)/2+1:size_fft(2))=...
    img_fft(size_fft(1)/2+1:size_fft(1),1:size_fft(2)/2);

end