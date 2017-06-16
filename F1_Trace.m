
% clear;
% clc;
% close all;
% 
% load Output.mat
% 


function F1_Trace(CenterCell,Output,T_start,T_end)

% plot correlation to a given cell's response during T_start to T_end


CenterSignal = Output.Cell(CenterCell).Signal;
Mask=zeros(Output.Picsize,Output.Picsize);

for i=1:Output.cn

    Mask=Mask+ROIsMask(Output.RoIs,i,Output.Picsize)*(sum(sum(corrcoef(CenterSignal(T_start:T_end),Output.Cell(i).Signal(T_start:T_end))))-2)/2;

end

figure(2)

imagesc(Mask)
colormap(summer)
colorbar;


% PlotROIs(RoIs)






