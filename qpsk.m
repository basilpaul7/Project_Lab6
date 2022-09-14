% Plots BER versus E_b/N_0 for QPSK modulation
close all;

N=2*50000;
EbN0dB = -10:2:10;
len = length(EbN0dB);
BER = zeros(1,len);
SER = zeros(1,len);

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
    s = sI + j * sQ;

    % AWGN channel
    xI = sI+wI;
    xQ = sQ+wQ;

    %QPSK detection
    bIhat = (xI >=0);
    bQhat = (xQ >=0);
    shat = (2*bIhat-1) + j * (2*bQhat-1);

    bhat(1:2:N) = bIhat;
    bhat(2:2:N) = bQhat;

    BER(ii) = sum(bhat ~= b)/N;
    SER(ii) = 2*sum(shat ~= s)/N;
end

plot(EbN0dB, BER,'m','LineWidth',2)
%plot(EbN0dB, BER,'m')
xlabel('$E_b/N_0$ in dB','Interpreter','latex')
ylabel('BER')
grid on
title('BER versus SNR per bit for BPSK','FontSize',12)

figure
plot(EbN0dB, SER,'b','LineWidth',2)
%plot(EbN0dB, SER,'b')
xlabel('$E_b/N_0$ in dB','Interpreter','latex')
ylabel('SER')
grid on
title('SER versus SNR per bit for BPSK','FontSize',12)
