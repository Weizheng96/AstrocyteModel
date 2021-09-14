% IP3R
K_IP3R_I=2;
K_IP3R_I_inactive=2;
K_IP3R_C_act=0.1;
K_IP3R_C_inh=5;
n_IP3R_I=2;
n_IP3R_C_act=4;
n_IP3R_C_inh=4;
% serca
K_serca=0.5;
Ratio=3;
% Mitochondria
K_mito=0.1;
B_mito=1;

TimeLength_s=30;
TimeUint=0.001;
TimeLength=round(TimeLength_s/TimeUint);
IP3input_total=0;


%%
% input = normpdf(1:TimeLength,1/TimeUint,0.01/TimeUint)*0.1+normpdf(1:TimeLength,5/TimeUint,0.01/TimeUint)*0.1;
input_IP3 = normpdf(1:TimeLength,2/TimeUint,1/TimeUint)*IP3input_total-...
    normpdf(1:TimeLength,10/TimeUint,4/TimeUint)*IP3input_total;
Ca_Overall=0.3;

C0=0.1; I0=0.2;
C=0.1; I=0;

%%
pi=Hill(I0,n_IP3R_I,K_IP3R_I_inactive);
Ca_constant=Ca_Overall*Ratio*pi*Hill(C0,n_IP3R_C_act,0.1)*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C0);
C_line=1.1.^(-40:35);
p0_line=Hill(C_line,n_IP3R_C_act,0.1).*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C_line);
serca_line=Hill(C_line,1,K_serca)-Hill(0.1,1,K_serca)+Ca_constant+Mito(C_line,K_mito,B_mito);
semilogx(C_line,p0_line*Ratio);
hold on;
plot(C_line,serca_line);
%%

C_history=zeros(TimeLength,1);
I_history=zeros(TimeLength,1);
TimeAxis=TimeUint:TimeUint:TimeLength*TimeUint;
for i=1:TimeLength
    I=I+input_IP3(i);
    I_history(i)=I;
end
I_history=max(I_history,0);
load("input.mat");
I_history=y*IP3input_total+I0;

pi=Hill(I0,n_IP3R_I,K_IP3R_I_inactive);
Ca_constant=Ca_Overall*Ratio*pi*Hill(C0,n_IP3R_C_act,0.1)*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C0);

for i=1:TimeLength
    pi=Hill(I_history(i),n_IP3R_I,K_IP3R_I);
    
    Ca_IP3R=Ca_Overall*Ratio*pi*Hill(C,n_IP3R_C_act,0.1)*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C);
    Ca_serca=Ca_Overall*(Hill(C,1,K_serca)-Hill(C0,1,K_serca))+Ca_constant+Mito(C,K_mito,B_mito);
    C=C+(Ca_IP3R-Ca_serca)*TimeUint;
    C_history(i)=C;
    if mod(i,100)==0
        subplot(2,1,1);
        IP3R_line=Ca_Overall.*Ratio.*pi.*Hill(C_line,n_IP3R_C_act,0.1).*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C_line);
        serca_line=Ca_Overall.*(Hill(C_line,1,K_serca)-Hill(0.1,1,K_serca))+Ca_constant+Mito(C_line,K_mito,B_mito);
        semilogx(C_line,IP3R_line);
        hold on;
        plot(C_line,serca_line);
        plot([C C],[Ca_IP3R Ca_serca]);
        ylim([0 1]);
        hold off;
        title(i*TimeUint+"(s)");
        legend("IP3R","other channel","current Ca^{2+}");
        xlabel("Ca^{2+} concentration (\MuM)");
        ylabel("Ca^{2+} flux (\muM/s)");
        subplot(2,1,2);
        plot(TimeAxis,I_history);
        ylabel("IP3 concentration (\muM)");
        xlabel("time (s)")
        ylim([0 2.5]);
        hold on;
        scatter(i*TimeUint,I_history(i));
        hold off;
        title("IP3 concentration");
%         ylim([0 Ca_Overall*10]);
        pause(0.01);
    end
end
sgtitle("max Ca^{2+}="+max(C_history));
% figure;
% plot(I_history)
% hold on;
% plot(C_history)
% ylim([0 0.2]);

cnt=3;
y_c(:,cnt)=C_history;
y_i(:,cnt)=I_history;