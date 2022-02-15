%%%%%%%%% Parameters setup function %%%%%%%%%
%%%   Yicheng Zhang, CS, L-CAS, UoL   %%%
%%%  created on 28/Sept./2021         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
%
% 
% 
%--------------------------------------------------------------------------
% global struct params
function initparams(FileName)
    arguments
        FileName char 
    end
    % pre-processing
    params.preproctype=0;
    
    % module flags
    params.ispersist=0;  % persistant flag
    params.isffm=0;      % FFM flag
    params.isffi=0;      % FFI flag
    params.isoo=0;  %output optimization
    params.isih=0; % output inhibition
    
    % P-layer
    params.pu=0.25;
    params.npi=0;
    
    % EI-layer
    params.wi=[0.125,0.25,0.125;0.25,0,0.25;0.125,0.25,0.125];
    
    % S-layer
    params.WI=0.7;
    
    % G-layer
    params.deltaC=0.01;
    params.Cw=4;
    params.Tde=15;
    params.Cde=0.5;
    params.we=(1/9).*ones(3);    
    
    % spiking mechanism
    params.Ts=[];
    params.nts=4;
    params.nsp=3;
    
    % FFM
    params.amp=1;
    params.alt=0;
    params.aL=1;
    params.Tlt0=0;
    params.Tmp=0.7;  %
    params.deltaTlt=0.03;
    params.piit_up=235;
    params.piit_low=100;
    
    
    % FFI
    params.alphafj=0;
    params.TF0=80;
    params.alphaffi=0.02;
    params.na=3;
    
    % OM
    vname=[FileName,'.mat'];
    
 save(vname,'-struct','params','-mat');

end

