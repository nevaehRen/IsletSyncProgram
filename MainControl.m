addpath('J:\2. MATLAB Programs\24.kim\IsletSyncProgram')
% addpath('/Users/Nevaeh/Documents/MATLAB/kim/experimental/IsletSyncProgram')
clear;
clc;
close all;

%% ................................ %%
%% --0--.start : generate Output.mat
%% GenerateMat()

load Output.mat



%% ................................ %%
%% --1--. generate demo movie
%% F1_GenerateMovie(Output,pwd,[])

%% -------------------------------- %%




%% ................................ %%
%% --2--.  generate correlation position fig and pics

mkdir('2.correlation')

for i =1:Output.cn
    
figure(2)
set(gcf,'color',[1 1 1])
F1_Trace(i,Output,1,Output.t)
axis off;
Gif('Correlation.gif',i);
saveas(gcf,strcat('2.correlation/',num2str(i),'.png'))

end

%% -------------------------------- %%





%% ................................ %%
%% --3--.  generate traces 



Signal=[];

for i=1:Output.cn

Signal=[Signal; Output.Cell(i).Signal'];

end




figure(3)
set(gcf,'color',[1 1 1])

imagesc(Signal)












figure(1)
plot(Output.Cell(8).Signal(51:end),Output.Cell(13).Signal(51:end),'b.')

for i=51:624
    hold on
    h= plot(Output.Cell(8).Signal(i),Output.Cell(13).Signal(i),'ro');
    pause(0.1)
    delete(h)  
end







%% ................................ %%
%% --4--.  Phase Pair traces 



mkdir('4.PairPhase')

figure(4)

for i=1:Output.cn
    for j=i:Output.cn
hold on
h=plot(Output.Cell(i).Signal(51:end),Output.Cell(j).Signal(51:end),'b.');


PicName=strcat('4.PairPhase/-PhasePlot-',num2str(i),'s--end-',num2str(j),'.png');
title(PicName);
px=getframe(gcf);
imwrite(px.cdata,PicName);

delete(h)
    end
end



%% ................................ %%
%% --3--.  generate traces 


Signal=[];

for i=1:Output.cn
[Period,P_temp]  =  FFT_CellTrace(Output.Cell(i).Signal);

Signal=[Signal; P_temp(end:-1:1)'];

end


figure(3)
set(gcf,'color',[1 1 1])
P = Period(end:-1:1);
[X Y]=meshgrid(P,1:Output.cn);

h = surf(X,Y,Signal)
colormap(summer)
set(h,'edgecolor',[0.2 0.2 0.2])




for j=randi(Output.cn)
subplot(2,1,2)
plot(P,Signal(j,:))
subplot(2,1,1)
plot(Output.Time,Output.Cell(j).Signal,'r');

j
pause(0.5)
end





Activity = [];


for i=2:Output.cn
Activity = [Activity';Output.Cell(i).Signal(51:end)']';
end

figure(4)
imagesc(Activity)




