load('fish.mat');
ratio=0.3;
linewidth=2;
n=100;
y1=y*0.1;
y1 = y1+normrnd(0,y*0.1*ratio,size(y));
y1=smooth(y1,n);
y2=y*0.025;
y2 = y2+normrnd(0,y*0.02*ratio,size(y));
y2=smooth(y2,n);
y3=y*0.2;
y3 = y3+normrnd(0,y*0.2*ratio,size(y));
y3=smooth(y3,n);
x=TimeAxis;
subplot(2,3,1);
plot(x,y1,'Color',[0.9290 0.6940 0.1250],'LineWidth',linewidth);
ylim([0,0.3]);
xlabel("Time (s)",'FontSize',20)
ylabel({"Ca^{2+} change","\Delta F/F0"},'FontSize',20);
legend("NE stimulation only",'FontSize',12,'Location','north');
subplot(2,3,2);
plot(x,y2,'Color',[0.3010 0.7450 0.9330],'LineWidth',linewidth);
ylim([0,0.3]);
xlabel("Time (s)",'FontSize',20)
legend("Swim only",'FontSize',12,'Location','north');
subplot(2,3,3);
plot(x,y3,'Color','r','LineWidth',linewidth);
ylim([0,0.3]);
xlabel("Time (s)",'FontSize',20)
legend("NE stimulation + swim",'FontSize',12,'Location','north');



%%
load('rat.mat');
n=100;
y1=y*0.07;
y1 = y1+normrnd(0,y*0.1*ratio,size(y));
y1=smooth(y1,n);
y2=y*0.005;
y2 = y2+normrnd(0,y*0.02*ratio,size(y));
y2=smooth(y2,n);
y3=y*0.2;
y3 = y3+normrnd(0,y*0.2*ratio,size(y));
y3=smooth(y3,n);
x=TimeAxis;
subplot(2,3,4);
plot(x,y1,'Color',[0.9290 0.6940 0.1250],'LineWidth',linewidth);
ylim([0,0.3]);
xlabel("Time (s)",'FontSize',20)
ylabel({"Ca^{2+} change","\Delta F/F0"},'FontSize',20);
legend("LED stimulation only",'FontSize',12,'Location','north');
subplot(2,3,5);
plot(x,y2,'Color',[0.3010 0.7450 0.9330],'LineWidth',linewidth);
ylim([0,0.3]);
xlabel("Time (s)",'FontSize',20)
legend("Motor only",'FontSize',12,'Location','north');
subplot(2,3,6);
plot(x,y3,'Color','r','LineWidth',linewidth);
ylim([0,0.3]);
xlabel("Time (s)",'FontSize',20)
legend("LED stimulation + motor",'FontSize',12,'Location','north');

set(gcf,'Position',[100 100 1200 800])