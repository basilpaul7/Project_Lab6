N=10^5; % number of symbols

M = 4; % 4-PAM
MPAMSymbols = -M+1:2:M-1;e
MPAMTiled=repmat(MPAMSymbols,N,1)';

EbN0dB = 6:2:8; % SNR per bit
EsN0dB = 10*log10(log2(M)) + EbN0dB; %SNR
SER = zeros(1,length(EbN0dB));

beta=0.3; % roll-off factor
NsymSRRC=8; % symbol duration of pulse
L=8; %oversampling factor
[p, t, D] = srrcpulse(beta,NsymSRRC, L);
Ep = sum(abs(p).^2); %pulse energy

for ii=1:length(EsN0dB)
    snr = EsN0dB(ii);

    %Transmitter
    d = 2*randi(M,1,N) - (M+1); %M-PAM modulated symbols
    u = reshape([d;zeros(L-1,N)],1,L*N); %upsampling
    s = conv(u,p); %pulse-shaping

    % Channel
    Ps = L*sum(abs(s).^2)/length(s);
    N0 = Ps/10^(snr/10);
    n = sqrt(N0/2) * randn(1,length(s));
    r = s + n; %pass through a baseband AWGN channel
    
    % Receiver
    shat = conv(r,p); %matched filtering
    figure;
    plotEyeDiagram(shat,L,2*L,2*D,500);
    vhat = shat(2*D+1:L:end-2*D)/Ep; %downsample & scale by pulse energy 
    
    % Demodulation
    [minvals,indexvals] = min(abs(vhat-MPAMTiled));
    dhat = MPAMTiled(indexvals);

    % Computing symbol error rate
    SER(ii) = sum(dhat ~= d)/N;
end
plot(EbN0dB,SER,'g','LineWidth',1);
xlabel('$E_b/N_0$ in dB','Interpreter','latex');
ylabel('SER');
title('SER versus SNR per bit');
grid on;
disp("All Done!")
