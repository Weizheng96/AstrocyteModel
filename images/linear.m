n=700;
linewidth=4;
simu=1;
if simu==0
    noise_base_i=0.05;
    noise_base_c=0.1;
    ratio=0.6;
else
    ratio=0;
    noise_base_i=0;
    noise_base_c=0;
end
for cnt=2:6
    subplot(1,5,cnt-1);
    yyaxis left
    y0=y_i(:,cnt);
    noise=normrnd(0,(y0+noise_base_i)*ratio,size(y0));
    y=y0+noise;
    y=smooth(y,n);
    plot(x,y*70,'LineWidth',linewidth);
    ax = gca;
    ax.FontSize = 32; 
    ylim([0 10]);
    if cnt==2
        ylabel({"NE signal (\muM)"},'FontSize',40);
    end
    hold on; 
    yyaxis right
    y0=y_c(:,cnt);
    noise=normrnd(0,(y0+noise_base_c)*ratio,size(y0));
    y=y0+noise;
    y=smooth(y,n);
    if simu==0
        plot(x,y/12,'LineWidth',linewidth);
        ylim([0 0.3]);
    else
        plot(x,y+0.1,'LineWidth',linewidth);
        ylim([0 3]);
    end
    if cnt==6
        if simu==0
            ylabel({"Ca^{2+} signal","\DeltaF/F0"},'FontSize',20);
        else
            ylabel({"Ca^{2+} signal (\muM)"},'FontSize',40)
        end
        
    end
    xlabel("Time (s)",'FontSize',40);
end
set(gcf,'Position',[100 100 3000 600])
%%
print(gcf,'Linear_simulation.png','-dpng','-r300');  