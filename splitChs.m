function [chR,chG,chB]=splitChs(RGBframe)
 % get the indesity of every channel
    tr=RGBframe(:,:,1);
    tg=RGBframe(:,:,2);
    tb=RGBframe(:,:,3);
    % get special color channel data, in Uint8 format;
  chR=double(tr-floor(0.5*tg)-round(0.5*tb));
  chG=double(tg-floor(0.5*tr)-round(0.5*tb));
  chB=double(tb-floor(0.5*tg)-round(0.5*tr));


end
