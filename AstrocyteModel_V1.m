
TimeLength=20000;
TimeUint=0.001;
IP3input_total=0.001;


% input = normpdf(1:TimeLength,1/TimeUint,0.01/TimeUint)*0.1+normpdf(1:TimeLength,5/TimeUint,0.01/TimeUint)*0.1;
input_IP3 = normpdf(1:TimeLength,5/TimeUint,2/TimeUint)*1;
input_Ca = normpdf(1:TimeLength,1/TimeUint,0.1/TimeUint)*0;

% intial concentrate
C0=0.1; % 0.1 should is the balance
I0=0; % 0.01

% AM/PM
MODE=1; % 1 for AM, 2 for PM

% serca
MaxSpeed_serca=0.9;
n_serca=2;
Ka_serca=[0.1 0.05];

% IP3R
MaxSpeed_IP3R=64.865;
Ka_IP3R_I=0.13;
Ka_IP3R_C=0.08234;

% other
Other_Ca=0.45;

% IP-5P
r=[0.04 0.05];

% IP3-3K
MaxSpeed_3K=2;
Ka_3K=1;


% start simulation
C=C0;I=I0;
C_history=zeros(TimeLength,1);
I_history=zeros(TimeLength,1);
for i=1:TimeLength
    
    % Ca2+ change per timeuint
    Ca_serca=MaxSpeed_serca*Hill(C,n_serca,Ka_serca(MODE));
    Ca_IP3R=MaxSpeed_IP3R*(Hill(I,1,Ka_IP3R_I)*Hill(C,1,Ka_IP3R_C))^3;
    Ca=Ca_IP3R-Ca_serca+Other_Ca;
    dCa=input_Ca(i)+Ca*TimeUint;

    % IP3 change per timeuint
    IP3_5P=r(MODE)*I;
    IP3_3K=MaxSpeed_3K*Hill(I,1,Ka_3K);
    dIP3=input_IP3(i)-(IP3_5P+IP3_3K)*TimeUint;

    C=C+dCa;
    I=I+dIP3;

    C_history(i)=C;
    I_history(i)=I;
end

% plot
TimeAxis=TimeUint:TimeUint:TimeLength*TimeUint;
plot(TimeAxis,C_history)
hold on;
plot(TimeAxis,I_history*10)
legend("Calcium","IP3 (totally injected "+IP3input_total+" uM)")
ylabel("concentration (uM per cytosol volume)");
xlabel("time (s)");
