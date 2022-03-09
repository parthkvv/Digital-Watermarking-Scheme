%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dost2_tutorial (script)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% this script shows how to apply the dost2 and the idost2 to images.
% For more informations on the dost2 and the idost2  see the comments
% on their code.
%
% Code by: U. Battisti and L. Riba 
% July, 02 2014
%
% References:
% [1]   R.G. Stockwell, "Why use the S-Transform", Pseudo-differential 
%       operators partial differential equations and time-frequency 
%       analysis, vol. 52 Fields Inst. Commun., pages 279--309, 
%       Amer. Math. Soc., Providence, RI 2007;
% [2]   R.G. Stockwell, "A basis for efficient representation of the
%       S-transform", Digital Signal Processing, 17: 371--393, 2007;
% [3]   Y. Wang and J. Orchard, "Fast-discrete orthonormal 
%       Stockwell transform", SISC: 31:4000--4012, 2009;
% [4]   Y. Wang, "Efficient Stockwell transform with applications to 
%       image processing", PhD thesis, University of Waterloo, 
%       Ontario Canada, 2011;
% [5]   U. Battisti, L.Riba, "Window-dependent bases for efficient 
%       representation of the Stockwell transform", 2014
%       http://arxiv.org/abs/1406.0513.
%
%
% Additional details:
% Copyright (c) by U. Battisti and L. Riba
% $Revision: 1.0 $  
% $Date: 2014/07/02  $
%
%
% Summary:
% 1) read an image (we use the classical "Lena"); 
% 2) compute the dost coefficients of the signal;
% 3) compute the inverse dost of the dost to reconstruct the signal;
% 4) plot the signal, the dost coefficients and the reconstructed signal.


clear all
close all

% read the test-signal
test_signal  = double(imread('lena.bmp'));
test_signal(test_signal<0)=0;
% compute the dost coefficients of the signal "test_signal"
dost2_test_signal = dost2(test_signal);
%dost2_test_signal=real(dost2_test_signal);
dost2_test_signal(dost2_test_signal<0)=0;
J= imnoise((dost2_test_signal),'gaussian',0.001);
% J2 = imnoise(imag(dost2_test_signal),'gaussian',0.001);
% reconstruct the signal using the idost2
% J=J1+J2;
% K = wiener2(J,[5 5]);
reconstructed_test_signal = idost2(J);

x=psnr(real(reconstructed_test_signal),test_signal);
co=corr2(real(reconstructed_test_signal),test_signal);
figure
subplot(1,3,1)
imagesc(test_signal)
title('test signal')
axis equal 
axis tight
subplot(1,3,2)
%imagesc(log(abs(dost2_test_signal))) 
imagesc([-.5 .5], [-.5 .5], log(abs(dost2_test_signal))) 
title('(log of the norm of the) dost2 of the test signal')
axis equal
axis tight
subplot(1,3,3)
imagesc(real(reconstructed_test_signal))
title('reconstructed test signal')
axis equal
axis tight
colormap gray

