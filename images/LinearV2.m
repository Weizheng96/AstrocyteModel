n=700;
linewidth=4;
simu=0;
if simu==0
    noise_base_i=0.05;
    noise_base_c=0.01;
    ratio=0.6;
else
    ratio=0;
    noise_base_i=0;
    noise_base_c=0;
end

for cnt=1:6
    subplot(1,6,cnt);
    y0=y_c(:,cnt);
    noise=normrnd(0,(y0+noise_base_c)*ratio,size(y0));
    y=y0+noise;
    y=smooth(y,n);
    if simu==0
        plot(x,y/12,'LineWidth',linewidth,'Color','g');
        ylim([0 0.3]);
    else
        plot(x,y+0.1,'LineWidth',linewidth,'Color','g');
        ylim([0 3]);
    end
%     if cnt==1
%         if simu==0
%             ylabel({"Ca^{2+} signal","\DeltaF/F0"},'FontSize',20);
%         else
%             ylabel({"Ca^{2+} signal","(uM)"},'FontSize',20)
%         end
%     end
%     set(gca,'visible','off')
    set(gca,'XColor', 'none','YColor','none')
    if cnt==1
        title(0,'FontSize',30);
        legend("Astrocyte Ca^{2+} signal",'FontSize',30,'TextColor','g');
    else
        title(2^(cnt-2),'FontSize',30);
    end
end
set(gcf,'Position',[100 100 1700 300])