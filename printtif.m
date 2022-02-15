
function printtif(filename)
hfig = gcf;
picpath='./pics/';
figWidth = 6.3;  % 设置图片宽度
figHeight = 5;  % 设置图片高度
set(hfig,'PaperUnits','inches'); % 图片尺寸所用单位
set(hfig,'PaperPosition',[0 0 figWidth figHeight]);
picloc=[picpath,filename,'.'];
fileout = [picloc]; % 输出图片的文件名
print(hfig,[fileout,'tif'],'-r600','-dtiff'); % 设置图片格式、分辨率
