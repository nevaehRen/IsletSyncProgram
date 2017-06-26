function Spatial_StackFusionWaves(i)
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
set(gcf,'Position',[15   86  1405  690], 'color','w');

[sn sf]=size(RoIs); % fusion num per stack
Colors=jet(sf);         %渐变色索引
Indicatior=0*Tiff(:,:,1:3);   % 位置索引
colormap(Colors);

for j=1:sf
A=RoIs{j}.vnRectBounds;
A(A>512)=512;
A(A<=0)=1;
Signal=Tiff(A(1):A(3),A(2):A(4),:);      % 取出ROI对应TIF
Waves=mean(mean(Signal,1),2);
wave=reshape(Waves,400,1);

H2=subplot(1,2,2);


plot(wave,'Color',Colors(j,:));
hold on
Indicatior(A(1):A(3),A(2):A(4),1)=Colors(j,1);
Indicatior(A(1):A(3),A(2):A(4),2)=Colors(j,2);
Indicatior(A(1):A(3),A(2):A(4),3)=Colors(j,3);
end

P2=get(H2,'pos');
P2=P2+[-0.1 0 0.14 0];
set(H2,'pos',P2);

H1=subplot(1,2,1);

P1=get(H1,'pos');
P1=P1+[-0.1 0 0.03 0];
set(H1,'pos',P1);

imshow(Indicatior)
colormap(Colors)
colorbar;
PicName=strcat('Spatial-Stack-',num2str(i-1),'--','Fusion num-',num2str(sf),'.png');
title(PicName);
px=getframe(gcf);
imwrite(px.cdata,PicName);
close;