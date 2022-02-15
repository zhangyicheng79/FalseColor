%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% main detection script %%%%%%%%%
%%%   Yicheng Zhang, CS, L-CAS, UoL   %%%
%%%   Created on 28/12/2021           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CollisionDetect3Ch(Vfile)
%________________________________________
% Log
% 28/Dec/21:Created this function to make a detection in multi-colour-channels. 
% 04/Jan/22：Modified function:LGMD13Ch() to enable different parameters in 
%           different channels respectively.
% 06/Jan/22: Added function:wsgen(), enable multiple spike counters.
%_______________________________________


%% --------- Initial parameters ---------
% global params;
%SpikeCounter=0;
% global TotalPx;
i=0;
    % InitialParams;
    if exist('params.mat','file')
        params=load('params.mat');
        paramsR=load('paramsR.mat');
        paramsG=load('paramsG.mat');
        paramsB=load('paramsB.mat');
    else
        InitialParams;
        initparams('paramsR');
        initparams('paramsG');
        initparams('paramsB');
    end
tic

%% --------- Imread Video frames ---------
if exist(Vfile,'file')  
    try
       Vdata = VideoReader(Vfile); % load video file from path
    catch
        msgbox('Is it a correct video file? please check');
    end
else
    msgbox('read video file error,please check the video path');
end
TotalFrame=Vdata.NumFrames;  % video number of frames
Vheight=Vdata.Height;     
Vwidth=Vdata.Width;
params.TotalPx=Vheight*Vwidth;   % Total pixels in a frame
paramsR.TotalPx=Vheight*Vwidth;   % Total pixels in a frame
paramsG.TotalPx=Vheight*Vwidth;   % Total pixels in a frame
paramsB.TotalPx=Vheight*Vwidth;   % Total pixels in a frame



%% intial vars
LastFrame=readFrame(Vdata);  % 第1帧
CurrentFrame=readFrame(Vdata); %第2帧
% 若为三帧差法，则读入第3帧 
% NextFrame=readFrame(Vdata);  %第3帧

% split RGB data into three channels:
     [LfR,LfG,LfB]=splitChs(LastFrame);
     [CfR,CfG,CfB]=splitChs(CurrentFrame);
MaxLoop=TotalFrame-2;
% 预求一个两帧差
LastP=double(abs(rgb2gray(CurrentFrame)-rgb2gray(LastFrame)));
%分别初始化3个通道的第一个帧差值；
LPR=tempdiff(LfR,CfR);
LPG=tempdiff(LfG,CfG);
LPB=tempdiff(LfB,CfB);
persistR=zeros(Vheight,Vwidth);
persistG=persistR;
persistB=persistR;
persist=persistR;
% initial the size of intermediate vars;
KR=zeros(1,MaxLoop);
KG=KR;
KB=KR;
K=KR;
WS1=KR;
WS2=KR;
% kr=KR;
% kg=KG;
% kb=KB;

params.Ts=KR; 
Spikes=KR;
SpikesR=KR;
SpikesG=KR;
SpikesB=KR;
SPKS=KR;

% WarnSig=KR;
% SpikeCounter=KR;


%% detection loop
 while(hasFrame(Vdata))
     i=i+1;
% parfor i=1:MaxLoop

   %% refresh the frame buffers
    LastFrame=CurrentFrame;   %第2帧--> last;   
    CurrentFrame=readFrame(Vdata); %第3~n帧-->current;
    CF=double(rgb2gray(CurrentFrame));
    LF=double(rgb2gray(LastFrame));
  %split channels
     [LfR,LfG,LfB]=splitChs(LastFrame);
     [CfR,CfG,CfB]=splitChs(CurrentFrame);




    %% 3Chs of LGMD1 algorithm
    % 04/Jan/22：不同通道可以设置不同的LGMD参数()
  % 灰度生成一个曲线，用于和RGB分通道的比较
    [Pf,Kf,spk,npersist]=LGMD13Ch(CF,LF,LastP,persist,params); % params;
% 分别处理3个不同颜色通道的数据
   [PfR,KfR,spkR,npersistR]=LGMD13Ch(CfR,LfR,LPR,persistR,paramsR); %paramR

   [PfG,KfG,spkG,npersistG]=LGMD13Ch(CfG,LfG,LPG,persistG,paramsG); %paramG

      [PfB,KfB,spkB,npersistB]=LGMD13Ch(CfB,LfB,LPB,persistB,paramsB); %paramB


%%

%     Pfr(:,:,i)=abs(Pf);   
%     Pfl(i)=sum(Pfr,'all');
    % Membrane potential
%%%%%%%%%%%%%%%%%%%test parfor%%%%%%%%%%%%%%%%%%%%%%
    KR(i)=KfR;  % original Membrane potential
     KG(i)=KfG;
      KB(i)=KfB;
      K(i)=Kf;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     Spikes(i)=spk;
     SpikesR(i)=spkR;
    SpikesG(i)=spkG;
    SpikesB(i)=spkB;
    SPKS(i)=(spkR|spkG|spkB);
%     KR(i)=KfR;  % original Membrane potential
%      KG(i)=KfG;
%       KB(i)=KfB;
%     k(i)=kf;  % Membrane potential after output mediate
%      K(i)=0.299*(KR(i)-0.499)+0.587*(KG(i)-0.499)+0.114*(KB(i)-0.499);
%      K(i)=(KR(i)|KG(i)|KB(i));
%     %% FFM (optional)-- up to the value of isffm
%     if params.isffm
%        framedata=rgb2gray(Current_frame);
%        sigmaLf=sum(max(framedata)); % each column
%        sigmaLTf=sum(max(transpose(framedata)));
%        Ld=(sigmaLf+sigmaLTf)/(Vwidth+Vheight); %equation (14)
%          % equation (13)
%           if(Ld>Piit_up)   % the average luminance is larger than 230
%             Tit=Tit+params.aL*params.deltaTlt;  
%           elseif(Ld<Piit_low) % the average luminance is less than 180
%             Tit=Tit-params.aL*params.deltaTlt; 
%           else    %otherwise
%             Tit=0;
%           end %end of if(Ld>Piit_up) 
%         params.Ts(i)=params.alt*Tit+params.amp*params.Tmp;    % equation(12)  
%     else
%         params.Ts(i)=params.Tmp;
%     end
%     
%    %% output optimise tone mapping-- make it a seperate function
% 	if K(i)>=params.Ts(i)
%         k(i) =(2/pi).*asin(0.5+2*(K(i)-params.Ts(i)));
% 	else
%         k(i) = 0.4*(K(i)-0.5);
%     end
%     
%     %% Spiking mechanism
%     % output optimise switch
%         if params.isoo
%             Cfinal=k(i);
%         else
%             Cfinal=K(i);
%         end
%         
%         
%         if(Cfinal>=params.Ts(i))
%            Spikes(i)=1;
% %             SpikeCounter=SpikeCounter+1;
%         else
%             Spikes(i)=0;
% %             SpikeCounter=SpikeCounter-1;
%         end % end of if(app.kf(fri)>=Ts)
    
    %% FFI(optional)
        if params.isffi
        
             Tffi=zeros(1,TotalFrame-2);
             Ff=zeros(1,TotalFrame-2);

                       % Tf0=app.s.FFITFO;
                        %alphaffi=app.s.FFIaffi;
             na=params.na;
                        % alphafj
             xfj=1:na;
             params.alphafj=exp((-0.7).*xfj); 
              
                        if (i==1)
                            Tffi(i)=params.TF0;
                            Ff(i)=sum(sum(abs(LastP)))/params.TotalPx;
                        else
                            Tffi(i)=params.TF0+params.alphaffi*Tffi(i-1);  %caculate Tffi
                            if(i>na)
                                sigmaaf=sum(params.alphafj(1:na).*Ff((i-na):(i-1)));  
                                app.Ff(i)=sigmaaf+sum(sum(abs(LastP)))./params.TotalPx;
                            else
                                sigmaaf=sum(app.alphafj(1:i-1).*app.Ff(1:i-1));
                                app.Ff(i)=sigmaaf+sum(sum(abs(LastP)))./params.TotalPx;
                            end % end of if(ti>na)

                        end %end of  if ti==1
                        % Ff(ti)=alphafj(ti)*Ff(ti-1)+ sum(sum(abs(app.P_layer(:,:,fri-1))))/app.Frame_Pixel;             

               
                        % when Ff>Tffi then give out no Kf signal,and continue;               
                        if Ff(i)>Tffi(i)
                            Spikes(i)=0;       %inhibit the spike output;
                            % when this happen the frame spike will be clear;    
                        end% end of if app.Ff(ti)>app.Tffi(ti)

        
        end
    %%   collision warning signal;

     % here only count the spikes in a time window nts
         if i>params.nts
% %             WarnSig(i)=1;
%             SpikeCounter(i)=sum(SPKS(i-params.nts:i));
%                 if(SpikeCounter(i)>=params.nsp)
%                     WarnSig(i)=1;
%                 else
%                     WarnSig(i)=0;
%                 end
              WS1(i)=wsgen(SPKS,i,params.nts,params.nsp);
              WS2(i)=wsgen(Spikes,i,params.nts,params.nsp);

  
         end % end of (if i>params.nts)
    %% accumulate
%     if i>8
%         Km(i)=sum(K(i-6:i))./6;
%         if Km(i)>Km(i-1)
%             WarnSig(i)=1;
%         else
%             WarnSig(i)=0;
%         end
%     end

  %% refresh the arguments
  
   persistR=npersistR;
  persistG=npersistG;
   persistB=npersistB;
  persist=npersist;
%     persistR=npersistR;
%  persistG=npersistG;
%   persistB=npersistB;

   LPR=PfR;
   LPG=PfG;
   LPB=PfB;
   LastP=Pf;

 end % end of while/parfor loop
toc
% TotalFrame
% i
% plot(k);
% hold on;
%  plot(K,'-o');
% Output multi-channels' K-value
 subplot1(6,1,'Gap',[0 0.01]);
    subplot1(1);
        plot(KR,'r');
        ylabel('Red','Color','r');
        ylim([0.4 1]);
    subplot1(2);
        plot(KG,'Color','#308014');
        ylabel('Green','Color','#308014');
        ylim([0.4 1]);
    subplot1(3);
        plot(KB,'b');
        ylabel('Blue','Color','b');
        ylim([0.4 1]);
    subplot1(4);
        plot(K,'k');
        ylabel('gray');
        ylim([0.4 1]);
        
    subplot1(5);
       plot(SPKS,'m');
       ylabel({'P-color';'spikes'});
       hold on;
           %  Spikes(Spikes==0)=NaN;
           WS1(WS1==0)=NaN;
           plot(WS1,'r*');
          
subplot1(6);
      plot(Spikes,'Color','#0072BD');
       ylabel({'Grayscale';'spikes'});
        WS2(WS2==0)=NaN;
           plot(WS2,'r*');
           hold off;

                                % plot(Pfl);
% Framesrate = TotalFrame./toc;
%  save('Kf.mat','K','-mat');
%  % output the results diagrams         
%             subplot1(2,1,'Gap',[0 0.01]);
%             subplot1(1);
%             
%            % print membrance potential
%              HKf=plot(K,'b-o');
%              hold on;
%              Htrehold=plot(params.Ts,'g--');
%              
% %               Hkf=plot(k,'o-.');
%              % print spikes
%              Spikes(Spikes==0)=NaN;
% %              WarnSig(WarnSig==0)=NaN;
%              Hspk= plot(Spikes,'r*');
%            
%             ylabel('membrane potential');
%             xlim([1 TotalFrame]);
% % daspect([1 1 1]);
%          subplot1(2);
%           %set(Hcount,'PlotBoxAspectRatio',[1,0.5,0]);
% 			bar(SpikeCounter,'red');
%             Hcount=gca;
%             set(Hcount,'PlotBoxAspectRatio',[2,0.3,1],'Position',[0.10 0.04 0.85 0.75]);
%             xlabel('Frame');
%             ylabel('spikes count')
%             xlim([1 TotalFrame]);
%  legend([Htrehold,Hspk],'Threhold','spikes','Location','northwest');



%--------- Main Detection ---------


%--------- Output or Return Results ---------

end