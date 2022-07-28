N=10^3; % number of symbols

M = 2; % 4-PAM
MPAMSymbols = -M+1:2:M-1;

beta=0.3; % roll-off factor
NsymSRRC=8; % symbol duration of pulse
L=8; %oversampling factor
[p, t, D] = srrcpulse(beta,NsymSRRC, L);
Ep = sum(abs(p).^2);

%Transmitter
d = 2*randi(M,1,N) - (M+1); %M-PAM modulated symbols
u = reshape([d;zeros(L-1,N)],1,L*N); %upsampling
s = conv(u,p); %pulse-shaping

% We assume an ideal baseband channel with no noise
%r = conv(s,c);
EbN0dB = 15;
snr = 10*log10(log2(M))+EbN0dB;
Ps = L*sum(abs(s).^2)/length(s);
N0 = Ps/10^(snr/10);
n = sqrt(N0/2) * randn(1,length(s));
r = s+n;
    
% Receiver
shat = conv(r,p)/Ep; %matched filtering
figure;
plotEyeDiagram(shat,L,2*L,2*D,100);
disp("All Done!")


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