function F9_Hot_Contour_Correlation(Output,T_start,T_end,BinSize,num_cluster)
 
% clear
% clc
% T_start=0;
% T_end=900;
% BinSize=5;
% num_cluster=3;

Output=D1_Standard_Output;
Output=Index_Sorting_Fusion(Output,T_start,T_end);

 % 1. 取出指定时间内的fusion event
Index1=Output{2,1}>T_start&Output{2,1}<T_end;

for i=[1 2 3 7]
Output{i,1}=Output{i,1}(Index1,:);
end

FusionEvent=Output{7,1};  %所有释放位置


% 3. 计算密度矩阵，以30为边长的正方形ROI内fusion个数定义为该点密度
Region=[0 0;512 0;512 512;0 512];
[xx yy Density]=csintkern(FusionEvent,Region,30);


% 4. 画出密度矩阵的等值线，3条等高线分为4部分

figure(1);
C=contourf(xx,yy,Density,num_cluster);

colorbar;


% 5. 等高线数据被重新整理，
S=contourdata(C);
FusionNum=unique([S.level]);  % 所有的level
            
sisi=0;
for j=unique([S.level])
sisi=max(sum([S.level]==j),sisi);  % 计算每个等高线范围有多少个区域，最多为sisi个
end

% 6. 创建计算每个区域内fusion 事件 的index，每个能力记录在Fusion里，同等能力不同区域记录在FusionSeparation里
Fusion_separation=cell(num_cluster+1,sisi);
Time_separation=cell(num_cluster+1,sisi);
Fusion=cell(num_cluster+1,1);
Time=cell(num_cluster+1,1);

ss=1;

for Counnt=FusionNum
    k=find([S.level]==Counnt);
        ss=ss+1;
    SepartionNum(ss)=sum(size(k))-1;
    mm=1;
    Iindex=zeros(size(FusionEvent(:,1)));
    for j=k
        if sum(size(S(j).xdata))>4
        Fusion_separation{ss,mm}=inpolygon(FusionEvent(:,1),FusionEvent(:,2),S(j).xdata,S(j).ydata);
        Iindex=Iindex|Fusion_separation{ss,mm};
        Time_separation{ss,mm}=Output{2,1}(Fusion_separation{ss,mm},:);
        mm=mm+1;
        end
        Fusion{ss}=Iindex;
        if sum(Iindex)
        Time{ss}=Output{2,1}(Iindex,:);
        end
        
    end
end



figure(1)
 Color=jet(num_cluster+1);
m=1;
for i=2:num_cluster+1
for j=1:SepartionNum(i)
      text(mean(S(m).xdata),mean(S(m).ydata),num2str(j),'color',Color(i,:));
      m=m+1;
    end
end



% 7. Fusion{1 2 3 4} 是能力最差到最强，也就是空间密度从小到大

%其余区域的release
for i=2:num_cluster
Iindex=Iindex|Fusion{i};
end
Fusion{1}=~Iindex;
Time{1}=Output{2,1}(~Iindex,:);



% 把重复的删除
for i=2:num_cluster-1
Fusion{i}=Fusion{i}.*~Fusion{i+1};
Time{i}=Output{2,1}(~~Fusion{i});

for j=1:SepartionNum(i)
    if(~isempty(Fusion_separation{i,j}))
Fusion_separation{i,j}=Fusion_separation{i,j}.*~Fusion{i+1};
Time_separation{i,j}=Output{2,1}(~~Fusion_separation{i,j});
    end

end

end



% 8.从能力最强到最差画trace

figure
xbins=T_start:BinSize:T_end;
Fusion_Trace=cell(num_cluster+1,1);
AAA=[0 unique([S.level])];

for i=1:num_cluster+1
    subplot(num_cluster+1,1,num_cluster-i+2)
Fusion_Trace{i}=hist(Time{i},xbins);
hist(Time{i},xbins)
Max=max(hist(Time{i},xbins));
   ylabel(strcat('Ability',num2str(AAA(i))),'FontSize',8);
    VaildShadow(Output{9,1},Max,T_start,T_end)  
set(gca,'xlim',[T_start T_end]);

end















xbins=T_start:30:T_end;
Fusion_Trace=cell(num_cluster+1,1);
AAA=[0 unique([S.level])];

for i=1:num_cluster+1
Fusion_Trace{i}=hist(Time{i},xbins);
end





HotFusion =  xbins(Fusion_Trace{end,1}>0);

Hotnum=sum(size(HotFusion))-1;


[a ~]=size(Output{5,1}');
Cell=[1:a];

for i=1:Hotnum
    figure;
  set(gcf,'Position',[105   86  605  520]);

    F4F9_Single_Cell_Fusion_Trace(Output,HotFusion(i)-20,HotFusion(i)+20,Cell,.1)
  
    
    figure;
   set(gcf,'Position',[735   86  605  520]);

    F5_NoRanking_Secretion_Ranking(Output,HotFusion(i)-20,HotFusion(i)+20,Cell,.1)


end






























% 10.不同分泌能力区域相关性

% % figure;
% % for i=1:num_cluster+1
% %     subplot(num_cluster+1,1,num_cluster-i+2)
% % [acor,lag]=xcorr(Fusion_Trace{i},Fusion_Trace{end});
% % 
% % plot(lag,acor)
% % end

% 11. 同一能力不同区域对比
Fusion_Trace_separation=cell(num_cluster+1,sisi);
for i=2:num_cluster+1
    
    figure;
    for j=1:SepartionNum(i)
    subplot(SepartionNum(i),1,j)
Fusion_Trace_separation{i,j}=hist(Time_separation{i,j},xbins);
hist(Time_separation{i,j},xbins)
Max=max(hist(Time_separation{i,j},xbins));

  set(gca,'xticklabel',[]);
    set(gca,'XColor',[0.8 0.8 0.8]);
    set(gca,'yticklabel',[]);
 ylabel(num2str(j));
        VaildShadow(Output{9,1},Max,T_start,T_end)  
set(gca,'xlim',[T_start T_end]);
    end
        suptitle(strcat('Ability',' :',num2str(AAA(i)),' level: ',num2str(num_cluster+2-i)));
      set(gca,'xticklabel',T_start:60:T_end);
        set(gca,'xtick',T_start:60:T_end);

    set(gca,'XColor',[0 0 0]);

end
    


Temp=Fusion_Trace_separation{4,1};

for i=2:num_cluster+1
    
    figure;
    for j=1:SepartionNum(i)
    subplot(SepartionNum(i),1,j)

[acor,lag]=xcorr(Temp,Fusion_Trace_separation{i,j});
plot(lag,acor);


Max=max(hist(Time_separation{i,j},xbins));

  set(gca,'xticklabel',[]);
    set(gca,'XColor',[0.8 0.8 0.8]);
    set(gca,'yticklabel',[]);
 ylabel(num2str(j));
%set(gca,'xlim',[T_start T_end]);
    end
        suptitle(strcat('Correlation  Ability',' :',num2str(AAA(i)),' level: ',num2str(num_cluster+2-i)));
      set(gca,'xticklabel',T_start:60:T_end);
        set(gca,'xtick',T_start:60:T_end);

    set(gca,'XColor',[0 0 0]);

end

figure(1)
 PicName=strcat(Output{8,1},'-F9-Secretion Density-start-',num2str(T_start),'s--end-',num2str(T_end),'s.png');
 suptitle(PicName)
 px=getframe(gcf);
 imwrite(px.cdata,PicName);
 
 figure(2)
 PicName=strcat(Output{8,1},'-F9-Secretion Density trace-start-',num2str(T_start),'s--end-',num2str(T_end),'s.png');
 suptitle(PicName)
 px=getframe(gcf);
 imwrite(px.cdata,PicName);
 
 
 
 
 
 
