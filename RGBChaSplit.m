%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
% open video as a VideoReader object
v=VideoReader('./hotcup.mp4');
Gw=v.Width;
Gh=v.Height;
fn=v.NumFrames;    
% tstv=read(v,[1 fn]);

allWhite=uint8(zeros(Gh, Gw));
justR=uint8(zeros(Gh,Gw,3,fn));
justG=uint8(zeros(Gh,Gw,3,fn));
justB=uint8(zeros(Gh,Gw,3,fn));

 for i=1:fn 
     Graph=read(v,i);
     
     RedCh=Graph(:,:,1);
     justR(:,:,:,i)=cat(3,RedCh,allWhite,allWhite);
     GrnCh=Graph(:,:,2);
      justG(:,:,:,i)=cat(3,allWhite,GrnCh,allWhite);
     BluCh=Graph(:,:,3);
      justB(:,:,:,i)=cat(3,allWhite,allWhite,BluCh);
     
 end

% if(exist('Rch','MPEG-4'))
% delete Rch.mp4
% end
% if(exist('Grn','MPEG-4'))
% delete Grn.mp4
% end
% if(exist('Blu','MPEG-4'))
% delete Blu.mp4
% end
  TmStr=clock;

Rch_name=['Output_red',num2str(TmStr(2)),num2str(TmStr(3)),num2str(TmStr(4)),num2str(TmStr(5)),num2str(round(TmStr(6)))];
Gch_name=['Output_grn',num2str(TmStr(2)),num2str(TmStr(3)),num2str(TmStr(4)),num2str(TmStr(5)),num2str(round(TmStr(6)))];
Bch_name=['Output_blu',num2str(TmStr(2)),num2str(TmStr(3)),num2str(TmStr(4)),num2str(TmStr(5)),num2str(round(TmStr(6)))];
 
 Video_Rch=VideoWriter(Rch_name,'MPEG-4');
 Video_Rch.FrameRate=v.FrameRate;
 open(Video_Rch)
 writeVideo(Video_Rch,justR);
 close(Video_Rch);
 
 Video_Grn=VideoWriter(Gch_name,'MPEG-4');
 Video_Grn.FrameRate=v.FrameRate;
 open(Video_Grn)
 writeVideo(Video_Grn,justG);
 close(Video_Grn);
 
 Video_Blu=VideoWriter(Bch_name,'MPEG-4');
 Video_Blu.FrameRate=v.FrameRate;
 open(Video_Blu)
 writeVideo(Video_Blu,justB);
 close(Video_Blu);
 