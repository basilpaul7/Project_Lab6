% Performs Pulse Code Modulation and Reconstruction
% Plots the cuves, and computes the SNR.
close all;
clear all;

% Input signal generation
f = 2;
% sampling frequency 
fs = 16; 
t = [0:1/fs:1];
N = length(t);
x = 255*(sin(2*pi*f*t)+1.0)/2;
Px = 0.5*(max(x)-mean(x))^2;

Levels = [16,32,64,128,256];
Llen = length(Levels);
snrdB = zeros(Llen,1);

for ii = 1:Llen
  L = Levels(ii);
  % Quantizing to levels 0-(L-1) levels (log2(L)-bit quantizer)
  qx = (256/L)*floor(x*L/256);
  
  % Number bits of the encoder 
  R = log2(L);
  % Total length of binary stream
  M = R*N;
  % Encoded binary stream 
  CC = reshape(dec2bin(qx*L/256).',M,1);
  CCnum = str2num(CC);
  
  % Reconstructed signal 
  XX = (256/L) * bin2dec(reshape(CC.',R,N).').';
   
  % Stemming the binary sequence
  figure;
  subplot(2,1,1);
  stem(CCnum,"linewidth",2);
  xlabel('Time',"fontsize",12);
  ylabel('Encoded Bit Stream',"fontsize",12);
  title('PCM: Encoded bit stream',"fontsize",12);

  % Plotting sampled versus reconstructed signal
  subplot(2,1,2);
  plot(t, x,t, XX);
  grid on;
  xlabel('Time',"fontsize",12);
  ylabel('Amplitude',"fontsize",12);
  legend("Original signal", "Reconstructed signal");
  title('PCM: Original and Reconstructed Signals',"fontsize",12);

  % SNR calculation
  Pn = sum(power(XX-x,2))/N;
  snrdB(ii) = 10*log10(Px/Pn);
  disp(["SNR in dB for " num2str(log2(L)) "-bit encoder = " num2str(snrdB(ii))]);
end

figure;
plot(log2(Levels),snrdB,"-o");
grid on;
xlabel('Number of bits of encoder',"fontsize",12);
ylabel('SNR',"fontsize",12);
title('PCM: SNR versus Number of bits',"fontsize",12);
