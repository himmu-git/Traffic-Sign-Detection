clear all; 
close all;
img= imread('img20.png');
%img=imnoise(img,'salt & pepper',0.1);
figure;
original_img = img;
imshow(img);
title("Original Image")
%img = medfilt3(img);
img = imsharpen(img);    %%sharping of image
%title("Denoised Image")
%figure;
%imshow(img);
rgb_img = img;
lab_img = rgb2lab(rgb_img);  %% To L*a*b for better intensity


%making the intensity values in the range [0 1] by normalizing
L = lab_img(:,:,1)/100;
%performing adaptive histogram equalization
L1 = adapthisteq(L); %%for better contrast

%rescaling to original scale
lab_img(:,:,1) = L1*100;

output_img = lab2rgb(lab_img);
figure, imshow(output_img);
title('Histogram Equalized');
img_eq = output_img;

% set type 0 for red sign
% set type 1 for yellow sign
% set type 2 for blue sign
type = 0;

if (type == 0)
    
    tempimg = im2double(img_eq);
    
    red = tempimg(:,:,1);
    green = tempimg(:,:,2);
    blue = tempimg(:,:,3);
    
    x1 = 1/2.*((red-green)+ (red-blue));
    y1 = ((red-green).*(red-green)+(red-blue).*(green-blue)).^0.5;
    theta = acosd(x1./y1);
    if blue > green
        H = theta;
    else
        H = 360 - theta;
    end
    H = deg2rad(H);
    if sum(tempimg,3) ~= 0
        S=1- (3./sum(tempimg,3)).*min(tempimg,[],3);
    else
        S=1- (3./1).*min(tempimg,[],3);
    end
    I=sum(tempimg,3)./3;
    out1 = zeros(size(red));
    [M1,N1] = size(out1);
    for v1 = 1:M1
        for v2 = 1:N1
            if((((H(v1,v2) >=0 & H(v1,v2)<0.111*pi) | (H(v1,v2) >=1.8*pi & H(v1,v2)<2*pi)) & (S(v1,v2)>0.1 & S(v1,v2)<=1)) & (I(v1,v2)>0.12 & I(v1,v2)<0.8))
                out1(v1,v2) = 1;
            end
        end
    end
    hsv_color = rgb2hsv(img_eq); %% for better understanding of color
    c1 = 0.8939;
    c2 = 0.9999;
    for v1 = 1:M1
        for v2 = 1:N1
            if((hsv_color(v1,v2,1) > c1 & hsv_color(v1,v2,1) < c2))
                out1(v1,v2) = out1(v1,v2);
            else
                out1(v1,v2) = 0;
            end
        end
    end
    ClosedImage = imclose(out1,ones(18,18));
    ClosedImage = imfill(ClosedImage,'hole');
    ClosedImage = bwareaopen(ClosedImage,80);
elseif (type==1)
    hsv_color = rgb2hsv(img_eq);
    [M1,N1,xx] = size(hsv_color);
    c1 = 0.1222;
    c2 = 0.2111;
    out1 = zeros(M1,N1);
    for v1 = 1:M1
        for v2 = 1:N1
            if((hsv_color(v1,v2,1) > c1 & hsv_color(v1,v2,1) < c2))
                out1(v1,v2) = 1;
            else
                out1(v1,v2) = 0;
            end
        end
    end
    ClosedImage = imclose(out1,ones(15,15));
    ClosedImage = imfill(ClosedImage,'hole');
    ClosedImage = bwareaopen(ClosedImage,90);
else
     hsv_color = rgb2hsv(img_eq);
    [M1,N1,xx] = size(hsv_color);
    c1 = 0.416;
    c2 = 0.722;
    out1 = zeros(M1,N1);
    for v1 = 1:M1
        for v2 = 1:N1
            if((hsv_color(v1,v2,1) > c1 & hsv_color(v1,v2,1) < c2))
                out1(v1,v2) = 1;
            else
                out1(v1,v2) = 0;
            end
        end
    end
    ClosedImage = imclose(out1,ones(15,15));
    ClosedImage = imfill(ClosedImage,'hole');
    ClosedImage = bwareaopen(ClosedImage,90);
end