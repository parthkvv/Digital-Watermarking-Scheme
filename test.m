%image watermarking using DWT-SVD
clc
close all

alpha = 0.75; %embedding strength
I = double(imread('lena512.bmp'));
figure(1); imshow(uint8(I)); title('the image in which we insert watermark');

figure(2); imshow(uint8(I)); title('the image in which we applied DOST');
[LL1,HL1,LH1,HH1] =dwt2(I,'haar');
[LL2,HL2,LH2,HH2] =dwt2(LL1,'haar');
p=size(LL2);
%applying SVD on LL2
[Uy,Sy,Vy]=svd(LL2);
q=size(Sy);

%define watermark

I_w=imread('watermark.jpg');
I_w=I_w(:,:,1);
I1_w=imresize(I_w,p);
% I_b=im2bw(I1_w);
figure(3);imshow(I1_w);title('original  watermark');

%applying SVD on  watermark
[Uw,Sw,Vw]=svd(double(I1_w));

%embed wartermark
Smark = Sy + alpha*Sw;

%Rebuild the sub-hands using SVD
LL2_1=Uy*Smark*Vy';

%Apply inverse dwt to get watermarkedimage
LL1_1=idwt2(LL2_1,HL2,LH2,HH2,'haar');
I_1=idwt2(LL1_1,HL1,LH1,HH1,'haar');
figure(4);imshow(uint8(I_1));title('Watermarked Image');

I_1=double(I_1);
dost2 = ST.dost2(I_1);
figure(5);imshow(uint8(dost2));title('Watermarked Image&DOST');

%   J=imnoise(I_1,'salt', 0, 0.0001);
%  J=imnoise(I_1,'gaussian');
  J=imnoise(dost2,'salt & pepper',0.001);
% J = histeq(I_1);
% J=uint8(J);
 figure(6), imshow(uint8(J),[]); title(' noisy watermarked image& DOST');
dost2=double(J);
recdost = ST.idost2(ST.dost2(dost2));
% recdost = ST.idost2(ST.dost2(recdost));
figure(7); imshow(double(recdost)); title('the image in which we insert watermark idost');

%EXTRACTION
[LL1_wmv,HL1_wmv,LH1_wmv,HH1_wmv]=dwt2(recdost,'haar');
[LL2_wmv,HL2_wmv,LH2_wmv,HH2_wmv]=dwt2(LL1_wmv,'haar');
[Uy_wmv,Sy_wmv,Vy_wmv]=svd(LL2_wmv);
Swrec=(Sy_wmv - Sy)/alpha;
WMy=Uw*Swrec*Vw';
figure(8); imshow(uint8(WMy));title('Extracted Watermark');

WMy=1-WMy;
X11=corr2(WMy,I1_w);