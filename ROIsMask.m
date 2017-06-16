function flag=ROIsMask(RoIs,num,Picsize)


[X Y]=meshgrid(1:Picsize,1:Picsize);

Ayo=RoIs{num}.mnCoordinates;
Ayo=[Ayo;Ayo(1,:)];

flag = myinpolygon(X,Y,Ayo(:,1),Ayo(:,2));

% figure
% imshow(flag)



end



