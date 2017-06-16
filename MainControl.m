addpath('/Users/Nevaeh/Documents/MATLAB/kim/experimental/program')




clear;
clc;
close all;

% step0: generate Output.mat
GenerateMat()
load Output.mat


% step1: generate demo movie
F1_GenerateMovie(Output,pwd,[])





figure(2)

Output
F1_Trace(8,Output,1,Output.t)

F1_Trace(13,Output,1,Output.t)



figure(1)
plot(Output.Cell(8).Signal(51:end),Output.Cell(13).Signal(51:end),'b')



for i=51:624
    hold on
    h= plot(Output.Cell(8).Signal(i),Output.Cell(13).Signal(i),'ro');
    pause(0.1)
    delete(h)
    
end

% F1_Trace(Output,100,Output.t)




figure(2)

for i=1:35
    for j=i:35
hold on
h=plot(Output.Cell(i).Signal(51:end),Output.Cell(j).Signal(51:end),'b');


PicName=strcat('-PhasePlot-',num2str(i),'s--end-',num2str(j),'.png');
title(PicName);
px=getframe(gcf);
imwrite(px.cdata,PicName);

delete(h)
    end
end



figure(3)

for i=8
    hold on
h=plot(Output.Cell(8).Signal(51:end),'k:','linewidth',3);

end


Activity = [];


for i=2:Output.cn
Activity = [Activity';Output.Cell(i).Signal(51:end)']';
end

figure(4)
imagesc(Activity)




