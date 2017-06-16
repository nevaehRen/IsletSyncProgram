function StackFusionWaves(i)
File=dir('*.tif');
[k ~]=size(File);   % stack num
C=cell(k,1);
for l=1:k
C{l,1}=File(l).name;
end
Filename=sort_nat(C);

%i=8;    % stack2
i
PresentFile=Filename{i}
Yasuo= strcat(PresentFile(1:end-4),'_RoiSet.zip');
RoIs=ReadImageJROI(Yasuo);
Tiff=imreadstack(PresentFile);

figure;
[sn sf]=size(RoIs); % fusion num per stack
for j=1:sf
A=RoIs{j}.vnRectBounds;
A(A>512)=512;
A(A<=0)=1;
Signal=Tiff(A(1):A(3),A(2):A(4),:);      % 取出ROI对应TIF
Waves=mean(mean(Signal,1),2);
wave=reshape(Waves,400,1);

plot(wave);
hold on
end
PicName=strcat('Stack-',num2str(i-1),'--','Fusion num-',num2str(sf));
title(PicName);

saveas(gcf,strcat(PicName,'.png'))