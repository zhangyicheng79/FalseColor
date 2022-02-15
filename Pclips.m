cd testvideo
clips=dir('*.mp4');
for i=1:length(clips)
    CD3ChLGN(clips(i).name)
    clipname=clips(i).name;
    picname=clipname(1:end-4);
    printtif(picname);
end
