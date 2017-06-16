function sequence=FusionSequenceAndDelay(NuM)
disp('Make Sure Excel Sheet3 First Column as Real Time')
%NuM=4;
File=dir('*.xls');
[k ~]=size(File);   % stack num
C=cell(k,1);
for l=1:k
C{l,1}=File(l).name;
end
Filename=C;
j=1;
Data=xlsread(C{j});
Data(isnan(Data(:,1)),:)=[];

Index=find(Data(:,1)==1);
Tiff=zeros(512,512,3);
N1=Index(NuM);
Colors=jet(N1);

RoIs=ReadImageJROI('isletRoiSet.zip');
[ss sf]=size(RoIs);

%StackCell(NuM);

Cell=[];
for m=1:sf
    Ayo=RoIs{m}.mnCoordinates;
Cell=[Cell myinpolygon(Data(1:N1-1,7),Data(1:N1-1,6),Ayo(:,1),Ayo(:,2))];
end

Cell(:,end)=[];  % É¾µô×î´óµÄ¿ò¿ò
[rows columns]=find(Cell'==1); %ÊÍ·ÅÏ¸°ûË³Ðò
Time=xlsread(C{j},3);
Delay=Time(columns(2:end,1),1)-Time(columns(1:end-1,1),1);
[aaa ~]=size(rows);
sequence=zeros(1,aaa);


sequence(1,:)=rows';
sequence(2,:)=[0;Delay]';


%sequence(1,1:2:end)=rows';

%sequence(1,2:2:end-1)=Delay';



figure

title1=suptitle(strcat(' Stack-',num2str(NuM)));
set(title1,'FontSize',10,'Color',[1 0 0]);

subplot(2,2,1)
xbins1=0:0.2:70;
hist(Delay,xbins1);
[Counts ~]=hist(Delay,xbins1);
title('Delay Time Distribution')

%figure
subplot(2,2,2)

xbins=1:sf-1;
hist(rows,xbins);
title('Cell Fusion Num Distribution');


%figure
subplot(2,2,3);

plot(Delay);
title('Delay between Fusion Events')

ttime=Time(1:aaa,1);

%figure
subplot(2,2,4)

xxbins=ttime(1,1):5:ttime(end,1);
hist(ttime,xxbins);
title('Funsion Trace as Time')






%sequence=sequence';

%figure;
%imagesc(Cell)
%sequence




