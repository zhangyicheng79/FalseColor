function tdfdat=tempdiff(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%--------------------------------------------------------------------------
%  tempdiff function returns tdfdat
% Input args:
%    two or three frames' data in single-channel or grayscale.
%__________________________________________________________________________
%  temporal different of frames
%
% Created: 27th Dec. 2021
% Zhang Yicheng 
% -------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 检查输入参数的个数，限定为2个或3个
minArgs=2;
maxArgs=3;
narginchk(minArgs,maxArgs);
% check if all the input args are 2D data;

    for i=1:nargin
        [v(i),h(i)]=size(varargin{i});
    end 

% chekc if all the frame data are in the same size

 

% Temporal Differents
    if nargin==2
        %帧间差法
        %验证输入是否为2维矩阵
        if (v(1)~=v(2))||(h(1)~=h(2))
            msgbox('Two input frames should be in the same size');
        else
            %求帧间差并返回结果：
            tdfdat=double(abs(varargin{2}-varargin{1}));
        end

    else
        %三帧差法
        if (v(1)~=v(2))||(h(1)~=h(2))||(v(1)~=v(3))||(h(1)~=h(3))
            msgbox('Three input frames should be in the same size');
        else
             %求三帧差并返回结果：
             tdftemp1=double(abs(varargin{2}-varargin{1}));
             tdftemp2=double(abs(varargin{3}-varargin{2}));
             tdfdat=tdftemp2&tdftemp1;
        end




    end




end
