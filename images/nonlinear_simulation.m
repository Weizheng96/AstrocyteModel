n=700;
linewidth=4;
simu=1;
fontsize=40;
if simu==0
    noise_base_i=0.05;
    noise_base_c=0.1;
    ratio=0.6;
else
    ratio=0;
    noise_base_i=0;
    noise_base_c=0;
end
for cnt=1:3
    subplot(1,3,cnt);
    yyaxis left
    y0=(y_i(:,cnt)-I0)*1.1*3.3;
    noise=normrnd(0,(y0+noise_base_i)*ratio,size(y0));
    y=y0+noise;
    y=smooth(y,n);
    plot(x,y,'LineWidth',linewidth);
    ax = gca;
    ax.FontSize = 32; 
    ylim([0 10]);
    ylim([0 10]);
    if cnt==1
        ylabel({"NE signal (\muM)"},'FontSize',fontsize);
    end
    hold on; 
    yyaxis right
    y0=y_c(:,cnt);
    noise=normrnd(0,(y0+noise_base_c)*ratio,size(y0));
    y=y0+noise;
    y=smooth(y,n);
    title("Ca^{2+} peak: "+round(max(y)*100) / 100+"(\muM)",'FontSize',fontsize)
    if simu==0
        plot(x,y/12,'LineWidth',linewidth);
        ylim([0 0.3]);
    else
        plot(x,y+0.1,'LineWidth',linewidth);
        ylim([0 3]);
    end
    if cnt==3
        if simu==0
            ylabel({"Ca^{2+} signal","\DeltaF/F0"},'FontSize',fontsize);
        else
            ylabel({"Ca^{2+} signal (uM)"},'FontSize',fontsize)
        end
        
    end
    xlabel("Time (s)",'FontSize',fontsize);
end
set(gcf,'Position',[100 100 3000 600])
%%
print(gcf,'Nonlinear_simulation.png','-dpng','-r300');  