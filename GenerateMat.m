
function GenerateMat()

addpath('/Users/Nevaeh/Documents/MATLAB/kim/experimental/program')


clear;
clc;

% 1. read tiff image
file=dir('islet*.tif');
Name=file(1).name;
Pic=imreadstack(Name);
[pix, ~, t] = size(Pic);
%%---------------%%
Output.Pic = Pic;
Output.t   = t;
Output.Picsize = pix;
%%---------------%%



Data = readtable(strcat(Name(1:end-4),'.csv'));
Data = table2struct(Data);
Time = 1:t;
for i=1:t
    if ischar(Data(i).Rel_Time_s_)
    Time(i) = str2num(Data(i).Rel_Time_s_);
    else
    Time(i) = Data(i).Rel_Time_s_;
    end
end
%%---------------%%
Output.Time = Time;
%%---------------%%



% 2. read RoI
RoIs = ReadImageJROI('RoiSet.zip');
[ss cn]=size(RoIs);
%%---------------%%
Output.RoIs = RoIs;
Output.cn   = cn;
%%---------------%%


% 3. Generate Signal

for i = 1:cn


flag=ROIsMask(RoIs,i,pix);
%  figure
% imshow(flag)

Signal=[];
for j=1:t
    Signal =[Signal; mean(mean(Pic(:,:,j).*flag))];
end


Ayo=RoIs{i}.mnCoordinates;
%%---------------%%
Output.Cell(i).Mask       = flag;
Output.Cell(i).location   = [mean(Ayo(:,1)) mean(Ayo(:,2))];
Output.Cell(i).Signal     = Signal;
%%---------------%%

end

% F1_GenerateMovie(Output,pwd,[])

save Output.mat


end
% figure;
% hold on
% axis([0 512 0 512]);
% set(gca,'Xtick',[]);
% set(gca,'Ytick',[]);
% set(gca,'color',[1,1,1]);
% % colormap(jet)
% imshow(imadjust(Pic(:,:,2)))


% PlotROIs(RoIs)





























