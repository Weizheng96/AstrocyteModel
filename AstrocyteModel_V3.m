clear;
TimeLength_s=20;
TimeUint=0.01;
TimeLength=round(TimeLength_s/TimeUint);

% input = normpdf(1:TimeLength,1/TimeUint,0.01/TimeUint)*0.1+normpdf(1:TimeLength,5/TimeUint,0.01/TimeUint)*0.1;
input_IP3_0 = (normpdf(1:TimeLength,2/TimeUint,1/TimeUint)-normpdf(1:TimeLength,10/TimeUint,4/TimeUint))*0.001;

% intial concentrate
C0=0.10; % 0.1 should is the balance
I0=0.01; % 0.01

% serca

n_serca=2;


% IP3R
K_IP3R_C_act=0.1;


n_IP3R_I=2;
n_IP3R_C_act=1.5;
n_IP3R_C_inh=3;

P_max=0.8;



% start simulation
C=C0;I=I0;


MaxSpeed_serca_lst=0.1:0.1:0.9;                             %1
K_serca_lst=0.1:0.1:0.5;                                    %2

MaxSpeed_IP3R_lst=[0.1 1 10 100];                           %3
K_IP3R_I_lst=0.01:0.01:0.1;                                 %4
K_IP3R_C_inh_max_lst=[0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8];    %5
IP3input_total_lst=[1 2 4 8 16 32 64 128 256];          %6

%
C_peaks_collection=zeros(length(MaxSpeed_serca_lst),length(K_serca_lst),length(MaxSpeed_IP3R_lst),length(K_IP3R_I_lst),length(K_IP3R_C_inh_max_lst),length(IP3input_total_lst));

for MaxSpeed_serca_cnt=1:length(MaxSpeed_serca_lst) %1
    disp(MaxSpeed_serca_cnt+"/"+length(MaxSpeed_serca_lst));
    MaxSpeed_serca=MaxSpeed_serca_lst(MaxSpeed_serca_cnt);
    for K_serca_cnt=1:length(K_serca_lst)           %2
        K_serca=K_serca_lst(K_serca_cnt);
        Other_Ca=MaxSpeed_serca*Hill(0.1,n_serca,K_serca);
        for MaxSpeed_IP3R_cnt=1:length(MaxSpeed_IP3R_lst)   %3
            MaxSpeed_IP3R=MaxSpeed_IP3R_lst(MaxSpeed_IP3R_cnt);
            for K_IP3R_I_cnt=1:length(K_IP3R_I_lst)         %4
                K_IP3R_I=K_IP3R_I_lst(K_IP3R_I_cnt);
                for K_IP3R_C_inh_max_cnt=1:length(K_IP3R_C_inh_max_lst)             %5
                    K_IP3R_C_inh_max=K_IP3R_C_inh_max_lst(K_IP3R_C_inh_max_cnt);
                    
                    for IP3input_total_cnt=1:length(IP3input_total_lst)             %6
                        IP3input_total=IP3input_total_lst(IP3input_total_cnt);
                        input_IP3 = input_IP3_0*IP3input_total;
                        C_peaks_collection(MaxSpeed_serca_cnt,K_serca_cnt,MaxSpeed_IP3R_cnt,K_IP3R_I_cnt,K_IP3R_C_inh_max_cnt,IP3input_total_cnt)...
                            =simulateV3(TimeLength,TimeUint,MaxSpeed_serca,n_serca,K_serca,K_IP3R_C_inh_max,n_IP3R_I,K_IP3R_I,n_IP3R_C_act,K_IP3R_C_act,n_IP3R_C_inh,MaxSpeed_IP3R,Other_Ca,C0,I0,input_IP3);
                    end
                    
                end
                
            end
            
        end
        
    end
    
end

%%

x_axis=IP3input_total_lst;

MaxSpeed_serca_cnt=1;%0.1:0.1:0.9;                             %1 -9
K_serca_cnt=1;%0.1:0.1:0.5;                                    %2 -5

MaxSpeed_IP3R_cnt=1;%[0.1 1 10 100];                           %3 -4
K_IP3R_I_cnt=1;%0.01:0.01:0.1;                                 %4 -10
K_IP3R_C_inh_max_cnt=1;%[0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8];    %5 -8

IP3input_total_cnt=1:9;%[1 2 4 8 16 32 64 128 256];       %6 -9

loglog(IP3input_total_lst,squeeze(C_peaks_collection(MaxSpeed_serca_cnt,K_serca_cnt,MaxSpeed_IP3R_cnt,K_IP3R_I_cnt,K_IP3R_C_inh_max_cnt,:)))

%%
%% serca: x: MaxSpeed || y: K_serca

x_axis=IP3input_total_lst;

MaxSpeed_serca_cnt=1;%0.1:0.1:0.9;                             %1 -9
K_serca_cnt=1;%0.1:0.1:0.5;                                    %2 -5

MaxSpeed_IP3R_cnt=3;%[0.1 1 10 100];                           %3 -4
K_IP3R_I_cnt=5;%0.01:0.01:0.1;                                 %4 -10
K_IP3R_C_inh_max_cnt=2;%[0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8];    %5 -8

IP3input_total_cnt=1:9;%[1 2 4 8 16 32 64 128 256 512];       %6 -9

for MaxSpeed_serca_cnt=1:9
    for K_serca_cnt=1:5
        ax(9*(K_serca_cnt-1)+MaxSpeed_serca_cnt)=subplot(5,9,9*(K_serca_cnt-1)+MaxSpeed_serca_cnt);
        plot(IP3input_total_lst,squeeze(C_peaks_collection(MaxSpeed_serca_cnt,K_serca_cnt,MaxSpeed_IP3R_cnt,K_IP3R_I_cnt,K_IP3R_C_inh_max_cnt,:)));
        title(MaxSpeed_serca_lst(MaxSpeed_serca_cnt)+" vs "+K_serca_lst(K_serca_cnt));
        ylim([0 1]);
    end
end

linkaxes(ax, 'xy')
sgtitle({'x: MaxSpeed of serca';'y: Hill equation K of serca for Ca^{2+}'});
%%  x: MaxSpeed_IP3R || y: K_IP3R_I
x_axis=IP3input_total_lst;

MaxSpeed_serca_cnt=1;%0.1:0.1:0.9;                             %1 -9
K_serca_cnt=1;%0.1:0.1:0.5;                                    %2 -5

MaxSpeed_IP3R_cnt=1;%[0.1 1 10 100];                           %3 -4
K_IP3R_I_cnt=1;%0.01:0.01:0.1;                                 %4 -10
K_IP3R_C_inh_max_cnt=2;%[0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8];    %5 -8

IP3input_total_cnt=1:9;%[1 2 4 8 16 32 64 128 256 512];       %6 -9

for MaxSpeed_IP3R_cnt=1:4
    for K_IP3R_I_cnt=1:10
        ax(4*(K_IP3R_I_cnt-1)+MaxSpeed_IP3R_cnt)=subplot(10,4,4*(K_IP3R_I_cnt-1)+MaxSpeed_IP3R_cnt);
        plot(IP3input_total_lst,squeeze(C_peaks_collection(MaxSpeed_serca_cnt,K_serca_cnt,MaxSpeed_IP3R_cnt,K_IP3R_I_cnt,K_IP3R_C_inh_max_cnt,:)));
        title(MaxSpeed_IP3R_lst(MaxSpeed_IP3R_cnt)+" vs "+K_IP3R_I_lst(K_IP3R_I_cnt));
        ylim([0 1]);
    end
end

linkaxes(ax, 'xy')
sgtitle({'x: MaxSpeed of IP3R';'y: Hill equation K of IP3R for IP3'})

%%  x: MaxSpeed_IP3R || y: K_IP3R_C_inh_max
x_axis=IP3input_total_lst;

MaxSpeed_serca_cnt=1;%0.1:0.1:0.9;                             %1 -9
K_serca_cnt=1;%0.1:0.1:0.5;                                    %2 -5

MaxSpeed_IP3R_cnt=1;%[0.1 1 10 100];                           %3 -4
K_IP3R_I_cnt=5;%0.01:0.01:0.1;                                 %4 -10
K_IP3R_C_inh_max_cnt=1;%[0.1 0.2 0.4 0.8 1.6 3.2 6.4 12.8];    %5 -8

IP3input_total_cnt=1:9;%[1 2 4 8 16 32 64 128 256 512];       %6 -9

for MaxSpeed_IP3R_cnt=1:4
    for K_IP3R_C_inh_max_cnt=1:8
        ax(4*(K_IP3R_C_inh_max_cnt-1)+MaxSpeed_IP3R_cnt)=subplot(8,4,4*(K_IP3R_C_inh_max_cnt-1)+MaxSpeed_IP3R_cnt);
        plot(IP3input_total_lst,squeeze(C_peaks_collection(MaxSpeed_serca_cnt,K_serca_cnt,MaxSpeed_IP3R_cnt,K_IP3R_I_cnt,K_IP3R_C_inh_max_cnt,:)));
        title(MaxSpeed_IP3R_lst(MaxSpeed_IP3R_cnt)+" vs "+K_IP3R_C_inh_max_lst(K_IP3R_C_inh_max_cnt));
        ylim([0 1]);
    end
end

linkaxes(ax, 'xy')
sgtitle({'x: MaxSpeed of IP3R';'y: Hill equation K_{inh} of IP3R for Ca^{2+}'})
%%
C_peaks_collection(1,1,3,5,2,5)