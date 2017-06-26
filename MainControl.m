
hello
addpath('/Users/Nevaeh/Documents/MATLAB/kim/experimental/IsletSyncProgram')
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



figure(4)

for i=1%randi(Output.cn)
    hold on
plot(1:3:530*3,Output.Cell(i).Signal,'color',[0.5 0.5 0.5],'linewidth',1);
plot(1:3:530*3,smooth(Output.Cell(i).Signal),'linewidth',2)
end




FFT_Cell = fft(Output.Cell(1).Signal')


plot(FFT_Cell)




Activity = [];


for i=2:Output.cn
Activity = [Activity';Output.Cell(i).Signal(51:end)']';
end

figure(4)
imagesc(Activity)




