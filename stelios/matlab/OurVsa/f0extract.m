clear all;
clc;

 
folder_name=uigetdir(path);
files = dir(fullfile(folder_name,'*.wav'));
files = {files.name};
[filpath,name,ext] = fileparts(folder_name);
 
audios_name = strcat(name,'/');

s = [];
fos = [];
maxvals = [];

for n = 1:length(files)
   word = files{n}
   
   [y,fs] = audioread(strcat(audios_name,word));
%    TotalTime = length(y)./fs;
%    t = 0:TotalTime/(length(y)):TotalTime-TotalTime/length(y);
%    f = figure();
%    subplot(2,1,1);
%    plot(t,y);
   y=y-mean(y(:));
   y=y/std(y(:));
%    subplot(2,1,2);
%    plot(t,y1);
%    keyboard
   ydft = fft(y);
   %figure();
   freq = 0:fs/length(y):fs/2;
   ydft = ydft(1:length(y)/2+1);
   
   for k = 1000 : length(ydft)
       ydft(1,k) = 0;
   end
   
   %plot(freq,abs(ydft));
   %xlim([0 1000]);

   
   [maxval,idx] = max(abs(ydft));
   fos(n,1) =  freq(idx);
   maxvals(n,1) = maxval; 
   
  
%    for i =1:length(y)
%        s(i,n) = y(i,1);
%        
%    end
end
saved_name = strcat(name,'_fos.m');
dlmwrite(saved_name,fos);

% [input,fs] = audioread('BREAK1.wav');
% [gci, goi] = dypsa(input, fs);
% impulseC(gci) = 1;
% impulseCT=impulseC';
% impulseO(goi)= 1;
% impulseOT=impulseO';
% subplot(3,1,1),plot(input((6500:8500),1)),title('Voiced Segment of thee Input signal'),axis('tight');
% subplot(3,1,2),plot(impulseCT((6500:8500),1),'r'),title('Impulse Signal, based on GCI'),axis('tight');
% subplot(3,1,3),plot(impulseOT((6500:8500),1),'b'),title('Impulse Signal, based on GOI'),axis('tight');

% TotalTime = length(s)./fs;
% t = 0:TotalTime/(length(s)):TotalTime-TotalTime/length(s);
% figure();
% plot(t,s(:,2)); 



%mean_fo = mean(fos)



