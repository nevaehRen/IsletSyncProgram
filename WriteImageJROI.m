function WriteImageJROI(varargin)
% WriteImageJROI - FUNCTION Write a matlab structurein to an ImageJ ROI
% Usage: WriteImageJROI(Pathname,Filename,Data)
%        WriteImageJROI(Filename,Data)
% 
% If the nTypeID is oval, the format of the input data should be [x,y,r]
% where (x,y) is the  center of a circle, and r is the radius of the circle
% 
% Write by wuyi at 2014.7.29
% The author has all the copyrigths. If you have any question, please contact with wuyihust@163.com 

if nargin ==2
    Pathname=cd;
    Filename=varargin{1};
    Data=varargin{2};
    t1=strfind(Filename,'.roi');
    Filebase=Filename(1:t1-1);
    fpath=strcat(Pathname,'\',Filebase);
else
    Pathname=varargin{1};
    Filename=varargin{2};
    Data=varargin{3};
    t1=strfind(Filename,'.roi');
    Filebase=Filename(1:t1-1);
    fpath=strcat(Pathname,Filebase);  
end
if ~exist(fpath,'dir') 
    mkdir(fpath);
end
n=length(Data(:,1));
left_up=[(Data(:,1)-Data(:,3)),(Data(:,2)-Data(:,3))];
right_down=[(Data(:,1)+Data(:,3)),(Data(:,2)+Data(:,3))];
for i=1:n
    strxv=int2str(round(Data(i,1)));
    lenk=length(strxv);
    for lk=lenk:3
        strxv=strcat('0',strxv);
    end
    stryv=int2str(round(Data(i,2)));
    lenk=length(stryv);
    for lk=lenk:3
        stryv=strcat('0',stryv);
    end
    fstr=strcat(stryv,'-',strxv,'.roi');
    fname=strcat(fpath,'\',fstr);
    fid = fopen(fname, 'wb');
    p1=floor(round(left_up(i,2))/256);
    p2=mod(round(left_up(i,2)),256); 
    p3=floor(round(left_up(i,1))/256);
    p4=mod(round(left_up(i,1)),256);
    p5=floor(round(right_down(i,2))/256);
    p6=mod(round(right_down(i,2)),256);
    p7=floor(round(right_down(i,1))/256);
    p8=mod(round(right_down(i,1)),256);
    head=[73 111 117 116 0 218 2 0 p1 p2 p3 p4 p5 p6 p7 p8];
    package=[head zeros(1,16) zeros(1,16) zeros(1,16)];
    fwrite(fid,package);
    fclose(fid);
end
fstr=strcat(fpath,'_Roi.zip');     
if exist(fstr,'file')
    delete(fstr)
end
zip(fstr,fpath);
files = dir(fpath);
for i=3:length(files)
    file=strcat(fpath,'\',files(i).name);
    delete(file);
end
rmdir(fpath);
