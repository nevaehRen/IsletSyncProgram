function Stack(NuM)
%NuM=6 ;%stack num

File=dir('*.xls');
[k ~]=size(File);   % stack num
C=cell(k,1);
for l=1:k
C{l,1}=File(l).name;
end
Filename=C;

for j=1:k
Data=xlsread(C{j});
Data(isnan(Data(:,1)),:)=[];

Index=find(Data(:,1)==1);
Tiff=zeros(512,512,3);
N1=Index(NuM);
Colors=jet(N1);

for i=1:N1-1
    
Y=Data(i,6);
X=Data(i,7);
A=[Y-1 X-1 Y+1 X+1];

A(A>512)=512;
A(A<=0)=1;
Tiff(A(1):A(3),A(2):A(4),1)=Colors(i,1);
Tiff(A(1):A(3),A(2):A(4),2)=Colors(i,2);
Tiff(A(1):A(3),A(2):A(4),3)=Colors(i,3);

end
figure;
imshow(Tiff)
colormap(Colors);
colorbar;
PicName=strcat(C{j}(1:end-4),'Fusion num-',num2str(N1-1),'Stack-',num2str(NuM),'.png');
title(PicName);
px=getframe(gcf);
imwrite(px.cdata,PicName);
close;
end