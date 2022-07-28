% Plots BER versus E_b/N_0 for BPSK modulation

N=100000;
EbN0dB = -10:0.5:10;
len = length(EbN0dB);
BER = zeros(1,len);

for ii = 1:len
  % Random binary sequence 
  b = randi(2,1,N)-1;
  
  N0 = power(10, -0.1*EbN0dB(ii));
  w = sqrt(N0/2) * randn(1,N);
  
  % BPSK modulation
  s = 2*b-1;
  % AWGN channel
  x = s+w;
  %BPSK detection
  bhat = (x >=0);
  
  BER(ii) = sum(bhat != b)/N;
end  

plot(EbN0dB, BER,"linewidth",2)
xlabel('E_b/N_0 in dB',"fontsize",18)
ylabel('BER',"fontsize",18)
grid on
title('BER versus SNR per bit for BPSK',"fontsize",18)
