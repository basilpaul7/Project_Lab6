N=10^5; % number of symbols

M = 4; % 4-PAM
MPAMSymbols = -M+1:2:M-1;
MPAMTiled=repmat(MPAMSymbols,N,1)';

EbN0dB = -8:2:12; % SNR per bit
EsN0dB = 10*log10(log2(M)) + EbN0dB; %SNR
SER = zeros(1,length(EbN0dB));

beta=0.3; % roll-off factor
NsymSRRC=8; % symbol duration of pulse
L=8; %oversampling factor
[p, t, D] = srrcpulse(beta,NsymSRRC, L);

figure;
plot(t,p,'r',"LineWidth",1);
xlabel('$t$','Interpreter','latex');
ylabel('$p(t)$','Interpreter','latex');
title("Root raised cosine pulse");
grid on;


%Transmitter
d = 2*randi(M,1,N) - (M+1); %M-PAM modulated symbols

figure;
stem(d(1:10),"LineWidth",1.5);
xlabel('$n$','Interpreter','latex');
ylabel('$d$','Interpreter','latex');
axis([0 11 -3.5 3.5])
xticks(1:10);
title("Message symbols");
grid on;

u = reshape([d;zeros(L-1,N)],1,L*N); %upsampling
s = conv(u,p); %pulse-shaping

figure;
plot((8:328)/8,s(8:328),"LineWidth",1);
xlabel('$t$','Interpreter','latex');
ylabel('$s(t)$','Interpreter','latex');
title("Pulse-shaped signal transmitted");
grid on;

Ep = sum(abs(p).^2); %pulse energy

for ii=1:length(EsN0dB)
    snr = EsN0dB(ii);

    % Channel
    Ps = L*sum(abs(s).^2)/length(s);
    N0 = Ps/10^(snr/10);
    n = sqrt(N0/2) * randn(1,length(s));
    r = s + n; %pass through a baseband AWGN channel

    figure;
    plot((8:328)/8,r(8:328),'r',"LineWidth",1);
    xlabel('$t$','Interpreter','latex');
    ylabel('$r(t)$','Interpreter','latex');
    title("Recieved signal");
    grid on;

    % Receiver
    shat = conv(r,p); %matched filtering
    figure;
    plot((8:328)/8,shat(8:328),"LineWidth",1);
    xlabel('$t$','Interpreter','latex');
    ylabel('$\hat{s}(t)$','Interpreter','latex');
    title("Output of matched filter");
    grid on;

    vhat = shat(2*D+1:L:end-2*D)/Ep; %downsample & scale by pulse energy

    figure;
    stem(vhat(1:10),"LineWidth",1.5);
    xlabel('$n$','Interpreter','latex');
    ylabel('$\hat{v}$','Interpreter','latex');
    xticks(1:10);
    title("Downsampled version of matched filter output");
    grid on;

    % Demodulation
    [minvals,indexvals] = min(abs(vhat-MPAMTiled));
    dhat = MPAMTiled(indexvals);

    figure;
    stem(dhat(1:10),"LineWidth",1.5);
    axis([0 11 -3.5 3.5])
    xlabel('$n$','Interpreter','latex');
    ylabel('$\hat{d}$','Interpreter','latex');
    xticks(1:10);
    title("Decoded symbols");
    grid on;

    % Computing symbol error rate
    SER(ii) = sum(dhat ~= d)/N;
end

figure();
plot(EbN0dB,SER,'g','LineWidth',1);
xlabel('$E_b/N_0$ in dB','Interpreter','latex');
ylabel('SER');
title('SER versus SNR per bit');
grid on;

function [p,t,D]=srrcpulse(beta,L,Nsym)
    Tsym=1;
    t=-Nsym/2:1/L:Nsym/2; %unit symbol duration time-base
    num = sin(pi*t*(1-beta)/Tsym)+ ((4*beta*t/Tsym).*cos(pi*t*(1+beta)/Tsym));
    den = pi*t.*(1-(4*beta*t/Tsym).^2)/Tsym;
    p = 1/sqrt(Tsym)*num./den; %srrc pulse definition

    %handle corner cases (singularities)
    p(ceil(length(p)/2))=1/sqrt(Tsym)*((1-beta)+4*beta/pi);

    temp = (beta/sqrt(2*Tsym))*( (1+2/pi)*sin(pi/(4*beta)) + (1-2/pi)*cos(pi/(4*beta)));
    p(t==Tsym/(4*beta)) = temp;
    p(t==-Tsym/(4*beta)) = temp;
    
    %FIR filter delay = (N-1)/2, N=length of the filter
    D = (length(p)-1)/2; %FIR filter delay
end
