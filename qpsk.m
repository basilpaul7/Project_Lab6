% Plots BER versus E_b/N_0 for QPSK modulation
close all;

N=2*50000;
EbN0dB = -10:0.5:10;
len = length(EbN0dB);
BER = zeros(1,len);

for ii = 1:len
  b = zeros(1,N);
  bhat = zeros(1,N);

  % Random binary sequence 
  b = randi(2,1,N)-1;
  bI = b(1:2:N);
  bQ = b(2:2:N);
  
  N0 = power(10, -0.1*EbN0dB(ii));
  wI = sqrt(N0/2) * randn(1,N/2);
  wQ = sqrt(N0/2) * randn(1,N/2);  
  
  % QPSK modulation 
  sI = 2*bI-1;
  sQ = 2*bQ-1;
  
  % AWGN channel 
  xI = sI+wI;
  xQ = sQ+wQ;
  
  %QPSK detection 
  bIhat = (xI >=0);
  bQhat = (xQ >=0);
  bhat(1:2:N) = bIhat;
  bhat(2:2:N) = bQhat;
  
  BER(ii) = sum(bhat != b)/N;
end  

plot(EbN0dB, BER,"linewidth",2);
xlabel('E_b/N_0 in dB',"fontsize",18);
ylabel('BER',"fontsize",18);
grid on;
title('BER versus SNR per bit for QPSK',"fontsize",18);
