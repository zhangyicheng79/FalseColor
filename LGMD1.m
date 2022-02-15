function [Pf,Kret,npersist] = LGMD1(Current_frame,...
    Last_frame,Last_P,persist,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%--------------------------------------------------------------------------
%  LGMD1 function returns last Pf, Kf, kf, and npersist
% Input args:
%    1. Current_frame  Uint8 RGB image;
%    2. Last_frame     Uint8 RGB image;
%    3. Last_P       double gray image;
%    4. persist      double gray image;
%__________________________________________________________________________
%  LGMD1 function
%
% 23rd Sep. 2019
% modified on 22/09/2021 for multiple colors
% Zhang Yicheng 
% -------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




Cf=double(rgb2gray(Current_frame));
Lf=double(rgb2gray(Last_frame));
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


%update the persistance    
npersist=0;
end

