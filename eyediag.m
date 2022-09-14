N = 10^3; % number of symbols
M = 2; % 2-PAM
% M = 4; % 4-PAM

MPAMSymbols = -M+1:2:M-1;
beta = 0.3; % roll-off factor
% beta = 0.5;
% beta = 0.8;
NsymSRRC = 8; % symbol duration of pulse
L = 8; %oversampling factor
[p, t, D] = srrcpulse(beta,NsymSRRC, L);
Ep = sum(abs(p).^2);

%Transmitter
d = 2*randi(M,1,N) - (M+1); %M-PAM modulated symbols
u = reshape([d;zeros(L-1,N)],1,L*N); %upsampling
s = conv(u,p); %pulse-shaping

EbN0dB = 15;
snr = 10*log10(log2(M))+EbN0dB;
Ps = L*sum(abs(s).^2)/length(s);
N0 = Ps/10^(snr/10);
n = sqrt(N0/2) * randn(1,length(s));
% n = 0;
r = s+n;

% Receiver
shat = conv(r,p)/Ep; %matched filtering
figure;
plotEyeDiagram(shat,L,2*L,2*D,50);


%L - oversampling factor
%num_samp - num of samples per trace - set to as nL for integer n
%offset - initial offset in the data from where to begin plotting
%num_trace - number of traces to plot

function [eye_vals] = plotEyeDiagram(x,L,num_samp,offset,num_trace)
    total_samp = (num_samp*num_trace);%total number of samples
    eye_vals = reshape(x(offset+1:(offset+total_samp)),num_samp,num_trace);
    t = (0 : 1 : num_samp-1)/L;
    plot(t, eye_vals);
    title('Eye Diagram');
    xlabel('$t/T_{sym}$','Interpreter','latex');
    ylabel('Amplitude');
end


%Function for generating square-root raised-cosine (SRRC) pulse
% beta - roll-off factor of SRRC pulse,
% L - oversampling factor (number of samples per symbol)
% Nsym - filter span in symbol durations
%Returns the output pulse p(t) that spans the discrete-time base
%-Nsym:1/L:Nsym. Also returns the filter delay when the function
%is viewed as an FIR filter

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
