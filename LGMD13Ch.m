function [Pf,Kret,spk,npersist] = LGMD13Ch(Current_frame,...
    Last_frame,Last_P,persist,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%--------------------------------------------------------------------------
%  LGMD1 function returns last Pf, Kf, kf, and npersist
% Input args:
%    1. Current_frame  double or int16 single-chanel image;
%    2. Last_frame     double or int16 single-chanel image;
%    3. Last_P       double or int16 single-chanel image;
%    4. persist     double or int16 single-chanel image;
%__________________________________________________________________________
%  LGMD1 function for channel splits
%
% 23rd Sep. 2019
% modified on 22/09/2021 for multiple colors
% 30/12/2021: multi-channels split.
% Zhang Yicheng 
% -------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% Cf=double(rgb2gray(Current_frame));
% Lf=double(rgb2gray(Last_frame));
% When Current_frame and Last_frame are single channel data.
Cf=Current_frame;
Lf=Last_frame;
% Lp=Last_P;
%%% current frame difference;
    if persist==0
        Pf=abs(Cf-Lf);
    else
        Pf=double(Cf-Lf+persist);
    end
%%% I on current frame
If=conv2(Last_P,params.wi,'same'); 
%%% S layer  -- no ON/OFF
Sf=Pf-If.*params.WI; 
%%% G layer
  %% first of all, an average filter is applied to the S layer result
Ce=conv2(Sf,params.we,'same');
Omega=params.deltaC+max(max(abs(Ce)))./params.Cw;
Gf=Sf.*Ce./Omega;
oGf=Gf;
Gindex=oGf<(params.Tde/params.Cde); % value less than threhold
oGf(Gindex)=0;  % calculate the G~
% spiking mechanism

Kf=sum(oGf,'all'); % summery
%Kret is the membrance potential
Kret=logsig(Kf./params.TotalPx);% sigmoid
%  Kret = (1+exp(-Kf/params.TotalPx))^-1;
        if params.isih
            Kret=0.5+0.5*(Kret-0.5);
        end 

%% output optimization
    if Kret >=params.Tmp
        kret =(2/pi).*asin(0.5+2*(Kret-params.Tmp));
	else
        kret = 0.4*(Kret-0.5);
    end
%% output inhibition
%     if Kret >=params.Tmp
%         kret =(2/pi).*asin(0.5+2*(Kret-params.Tmp));
% 	else
%         kret = 0.4*(Kret-0.5);
%     end
    
    %% Spiking mechanism
    % output optimise switch
        if params.isoo
            Cfinal=kret;
        else
            Cfinal=Kret;
        end
        %%output inhibition

%generate spikes   
        
        if(Cfinal>=params.Tmp)
           spk=1;
%             SpikeCounter=SpikeCounter+1;
        else
            spk=0;
%             SpikeCounter=SpikeCounter-1;
        end % end of if(app.kf(fri)>=Ts)




%update the persistance    
npersist=0;
end

