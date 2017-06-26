function PlotROIs(RoIs)
% 3.Judge Cell Fusion Event
[ss sf]=size(RoIs);
ZuoBiao=[];
for m=1:sf
    Ayo=RoIs{m}.mnCoordinates;
ZuoBiao=[ZuoBiao;mean(Ayo(:,1)) mean(Ayo(:,2))];
end

for m=1:sf
    Ayo=RoIs{m}.mnCoordinates;
Ayo=[Ayo;Ayo(1,:)];
Ayo(Ayo>512)=512;
Ayo(Ayo<=0)=1;
[sa ~]=size(Ayo);
for jjj=2:sa
line(Ayo(jjj-1:jjj,1),Ayo(jjj-1:jjj,2),'color',[1 0 0],'Linestyle',':');
end
  text(mean(Ayo(:,1)),mean(Ayo(:,2)),num2str(m),'color',[1 0 0]);
end

end
