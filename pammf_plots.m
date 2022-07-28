figure
plot(t,p,'r',"LineWidth",1)
xlabel('$t$','Interpreter','latex');
ylabel('$p(t)$','Interpreter','latex');
title("Root raised cosine pulse");
grid on;

figure
stem(d(1:10),"LineWidth",1.5);
xlabel('$n$','Interpreter','latex');
ylabel('$d$','Interpreter','latex');
axis([0 11 -3.5 3.5])
xticks(1:10);
title("Message symbols");
grid on;

figure 
plot((8:328)/8,s(8:328),"LineWidth",1);
xlabel('$t$','Interpreter','latex');
ylabel('$s(t)$','Interpreter','latex');
title("Pulse-shaped signal transmitted");
grid on;

figure
plot((8:328)/8,r(8:328),'r',"LineWidth",1);
xlabel('$t$','Interpreter','latex');
ylabel('$r(t)$','Interpreter','latex');
title("Recieved signal");
grid on;

figure
plot((8:328)/8,shat(8:328),"LineWidth",1);
xlabel('$t$','Interpreter','latex');
ylabel('$\hat{s}(t)$','Interpreter','latex');
title("Output of matched filter");
grid on;

figure
stem(vhat(1:10),"LineWidth",1.5);
xlabel('$n$','Interpreter','latex');
ylabel('$\hat{v}$','Interpreter','latex');
xticks(1:10);
title("Downsampled version of matched filter output");
grid on;

figure
stem(dhat(1:10),"LineWidth",1.5);
axis([0 11 -3.5 3.5])
xlabel('$n$','Interpreter','latex');
ylabel('$\hat{d}$','Interpreter','latex');
xticks(1:10);
title("Decoded symbols");
grid on;