function C_peak=simulateV3(TimeLength,TimeUint,MaxSpeed_serca,n_serca,K_serca,K_IP3R_C_inh_max,n_IP3R_I,K_IP3R_I,n_IP3R_C_act,K_IP3R_C_act,n_IP3R_C_inh,MaxSpeed_IP3R,Other_Ca,C,I,input_IP3)

C_history=zeros(TimeLength,1);

for i=1:TimeLength
    % Ca2+ change per timeuint
    Ca_serca=MaxSpeed_serca*Hill(C,n_serca,K_serca);
    K_IP3R_C_inh=K_IP3R_C_inh_max*Hill(I,n_IP3R_I,K_IP3R_I);
    P0=0.8*Hill(C,n_IP3R_C_act,K_IP3R_C_act)*Hill(K_IP3R_C_inh,n_IP3R_C_inh,C);
    Ca_IP3R=MaxSpeed_IP3R*P0;
    Ca=Ca_IP3R-Ca_serca+Other_Ca;
    dCa=Ca*TimeUint;

    % IP3 change per timeuint
    dIP3=input_IP3(i);

    C=C+dCa;
    I=I+dIP3;
    
    C_history(i)=C;
end
C_peak=max(C_history);

end