figure;
TimeLength_s=30;
TimeUint=0.001;
TimeLength=round(TimeLength_s/TimeUint);
IP3input_total=80*0.001;


% input = normpdf(1:TimeLength,1/TimeUint,0.01/TimeUint)*0.1+normpdf(1:TimeLength,5/TimeUint,0.01/TimeUint)*0.1;
input_IP3 = normpdf(1:TimeLength,2/TimeUint,1/TimeUint)*IP3input_total-normpdf(1:TimeLength,10/TimeUint,4/TimeUint)*IP3input_total;

input_Ca = normpdf(1:TimeLength,1/TimeUint,2.5/TimeUint)*0;

% intial concentrate
C0=0.1; % 0.1 should is the balance
I0=0.01; % 0.01

% AM/PM
MODE=1; % 1 for AM, 2 for PM

% serca
MaxSpeed_serca=0.1;
n_serca=2;
K_serca=[0.1 0.05];

% IP3R
MaxSpeed_IP3R=10;%6*800;
K_IP3R_I=0.05;
K_IP3R_C_act=0.1;
K_IP3R_C_inh_max=0.2;

n_IP3R_I=2;
n_IP3R_C_act=1.5;
n_IP3R_C_inh=3;

P_max=0.8;

% other
Other_Ca=MaxSpeed_serca*Hill(0.1,n_serca,K_serca(MODE));

% IP-5P
r=[0 0.05];

% IP3-3K
MaxSpeed_3K=0;
K_3K=1;


% start simulation
C=C0;I=I0;
C_history=zeros(TimeLength,1);
I_history=zeros(TimeLength,1);
P0_history=zeros(TimeLength,1);
Pact_history=zeros(TimeLength,1);
Pinh_history=zeros(TimeLength,1);
K_IP3R_C_inh_history=zeros(TimeLength,1);
Ca_serca_history=zeros(TimeLength,1);
Ca_IP3R_history=zeros(TimeLength,1);
for i=1:TimeLength
    
    % Ca2+ change per timeuint
    Ca_serca=MaxSpeed_serca*Hill(C,n_serca,K_serca(MODE));
    K_IP3R_C_inh=K_IP3R_C_inh_max*Hill(I,n_IP3R_I,K_IP3R_I);
    P0=P_max*Hill(C,n_IP3R_C_act,K_IP3R_C_act)*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C);
    Ca_IP3R=MaxSpeed_IP3R*P0;
    Ca=Ca_IP3R-Ca_serca+Other_Ca;
    dCa=input_Ca(i)+Ca*TimeUint;

    % IP3 change per timeuint
    IP3_5P=r(MODE)*I;
    IP3_3K=MaxSpeed_3K*Hill(I,1,K_3K);
    dIP3=input_IP3(i)-(IP3_5P+IP3_3K)*TimeUint;

    C=C+dCa;
    I=max(I+dIP3,I0);
    
    K_IP3R_C_inh_history(i)=K_IP3R_C_inh;
    Pact_history(i)=Hill(C,n_IP3R_C_act,K_IP3R_C_act);
    Pinh_history(i)=Hill(K_IP3R_C_inh,n_IP3R_C_inh,C);
    Ca_serca_history(i)=Ca_serca;
    Ca_IP3R_history(i)=Ca_IP3R;
    P0_history(i)=P0;
    C_history(i)=C;
    I_history(i)=I;
end

% plot
TimeAxis=TimeUint:TimeUint:TimeLength*TimeUint;

subplot(2,2,1);
plot(TimeAxis,C_history);
hold on;
plot(TimeAxis,K_IP3R_C_act*ones(size(TimeAxis)));
plot(TimeAxis,K_IP3R_C_inh_history);
[Value,Index]=max(C_history);
scatter(TimeAxis(Index),Value,'filled');
ylim([0 inf]);
title("Calcium Peak="+TimeAxis(Index)+"(s), "+Value+"(uM)");
legend("Ca^{2+}","K_{act}","K_{inh}","Peak concentration");



subplot(2,2,3);
plot(TimeAxis,I_history)
% hold on;
% plot(TimeAxis,2*K_IP3R_I*ones(size(TimeAxis)));
title("IP3");
legend("IP3")
ylabel("concentration (uM)");
ylim([0 inf]);

subplot(2,2,2);
plot(TimeAxis,P0_history);
hold on;
% plot(TimeAxis,Pact_history);
plot(TimeAxis,Pinh_history);
title("P0")
ylabel("Probability");
xlabel("time (s)");
legend("P0","P_{inh}");
ylim([0 inf]);
subplot(2,2,4);
plot(TimeAxis,Ca_serca_history-Other_Ca);
hold on;
plot(TimeAxis,Ca_IP3R_history);
title("speed")
ylabel("uM");
xlabel("time (s)");
legend("serca - constant","IP3R");
ylim([0 inf]);

%%
IP3_lst=[0.01 0.02 0.05 0.08 0.16];
for i=1:5
    C=0.01:0.01:1;
    K_IP3R_C_inh=K_IP3R_C_inh_max.*Hill(IP3_lst(i),n_IP3R_I,K_IP3R_I);
%     Input=MaxSpeed_IP3R.*Hill(C,n_IP3R_C_act,K_IP3R_C_act).*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C)*P_max;
    Input=Hill(C,n_IP3R_C_act,K_IP3R_C_act).*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C)*P_max;
    Output=MaxSpeed_serca*Hill(C,n_serca,K_serca(MODE))-Other_Ca;
    subplot(5,1,i);
    semilogx(C, Input)
%     hold on;
%     [value,index]=min(abs(Input-Output));
    subplot(5,1,i);
%     scatter(C(index),value,'filled');
    ylim([0 1]);
    xlim([0 1000]);
    title("IP3="+IP3_lst(i)+"uM")
    ylabel("Probability");
    xlabel("Ca^{2+}");
    legend("flow speed","balance")
end

%%
IP3_lst=[0.01 0.02 0.04 0.08 0.16];
for i=1:5
    C=0.01:0.01:1000;
    K_IP3R_C_inh=K_IP3R_C_inh_max.*Hill(IP3_lst(i),n_IP3R_I,K_IP3R_I);
    Input=MaxSpeed_IP3R.*Hill(C,n_IP3R_C_act,K_IP3R_C_act).*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C)*P_max;
    Output=MaxSpeed_serca*Hill(C,n_serca,K_serca(MODE))-Other_Ca;
    subplot(5,1,i);
    semilogx(C, Input-Output)
    [value,index]=min(abs(Input-Output));
    subplot(5,1,i);
    hold on;
    scatter(C(index),value,'filled');
    ylim([-MaxSpeed_serca MaxSpeed_IP3R]);
    xlim([0 1000]);
    title("IP3="+IP3_lst(i)+"uM")
    ylabel("Probability");
    xlabel("Ca^{2+}");
    legend("flow speed","balance")
end
%%
IP3_lst=[0.00 0.01 0.05 0.1 1];
for i=1:5
    C=0:0.01:100;
    K_IP3R_C_inh=K_IP3R_C_inh_max.*Hill(IP3_lst(i),n_IP3R_I,K_IP3R_I);
    Pinh=Hill(K_IP3R_C_inh,n_IP3R_C_inh,C);
    subplot(5,1,i);
    semilogx(C,Pinh)
    ylim([0,1])
    title("IP3="+IP3_lst(i)+"uM")
    ylabel("Probability");
    xlabel("Ca^{2+}");
    
end