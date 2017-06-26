

function   F1_GenerateMovie(Output,Path0,aviod)

figure(1)
set(gcf,'color',[0 0 0])
colormap(hot);

Path0 = strcat(Path0,'/out.gif');

for i=[1:Output.t]
if ismember(i,aviod)
    continue;
end
    
imagesc(Output.Pic(:,:,i))
h=text(320,500,strcat('time=',num2str(Output.Time(i)),'s'),'color',[1 1 1],'fontsize',20);

axis off;

M=getframe(gcf);
M.cdata=imresize(M.cdata(:,:,:),[200,200]);
nn=frame2im(M);
[nn,cm]=rgb2ind(nn,256);


if i==1
imwrite(nn,cm,Path0,'gif','LoopCount',inf,'DelayTime',0.002);
else 
imwrite(nn,cm,Path0,'gif','WriteMode','append','DelayTime',0.002)
end

delete(h)


end

close 1;

end

