function orgb_img=rgb2orgb(input_img)
%%---------------------------------%%
% This function can convert a rgb image into an orgb one; 
% rgb_img  3-channel Uint8 RGB image;
% orgb_img  3-channel double oRGB image;
% 
%%---------------------------------%%
rgb_img=double(input_img);
%% step1: convert rgb to lcc image;
convcoef=[0.29,0.58,0.114;0.5,0.5,-1;0.866,-0.866,0];
[w,l,h]=size(rgb_img);
ropic=permute(rgb_img,[3,2,1]);
tilepic=reshape(ropic,h,w*l);
% re01 =[L; C1; C2]
re01=convcoef*tilepic; 

% codes below can output lcc format image.
% re02=reshape(re01,w,l,h);
% lcc_img=permute(re02,[3,2,1]);

%% step2: rotate the axis in colour gamut
%re03=[C1;C2]
re03=re01(2:3,:);
theta=atan(re03(2,:)./re03(1,:));
% 进行角度非线性仿射变换
temp01=theta>=(pi/3);
temp02=~temp01;

the01=temp01.*(pi/2+0.75.*theta-pi/3);
the02=1.5*temp02.*theta;
theta2=the01+the02;
% 得到仿射变换前后角度差
delta=theta2-theta;

% 求旋转系数矩阵
cosdel=cos(delta);
sindel=sin(delta);

rotbuf=[cosdel, -sindel,sindel,cosdel];

rotbuf01=reshape(rotbuf,length(delta),4);
rotbuf02=reshape(rotbuf01,length(delta),2,2);
rotmat=permute(rotbuf02,[3,2,1]);
cres=zeros(2,length(delta));
    for j=1:length(delta)
      cres(:,j)=rotmat(:,:,j)*re03(:,j);
    end
% cres =[Cyb;Crg]

%% step3: reconstruct the image in oRGB format
lum=re01(1,:);
result=[lum;cres];


re04=reshape(result,h,l,w);
% now we got the orgb image.
orgb_img=permute(re04,[3,2,1]);



end
