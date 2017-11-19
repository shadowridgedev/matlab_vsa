clear all;
clc;

a = 1;
input = 2;
[out1, out2] = VSAv1('abc')


% filename = 'voice.wav';
% 
% recObj = audiorecorder;
% disp('Start speaking.')
% recordblocking(recObj, 3);
% disp('End of Recording.');
% play(recObj);
% y = getaudiodata(recObj);
% fs=8000;
% 
% y=y-mean(y(:));
% y=y/std(y(:));
% 
% ydft = fft(y);
% freq = 0:fs/length(y):fs/2;
% ydft = ydft(1:length(y)/2+1);
% 
% [maxval,idx] = max(abs(ydft));
% fo =  freq(idx);





% v = [];
% maxtab = [];
% mintab = [];
% v=y;
% delta=0.5;
% x=0:0.01:((length(v)-1)/100);
% 
% mn = Inf; mx = -Inf;
% mnpos = NaN; mxpos = NaN;
% 
% lookformax = 1;
% 
% for i=1:length(v)
%   this = v(i);
%   if this > mx, mx = this; mxpos = x(i); end
%   if this < mn, mn = this; mnpos = x(i); end
%   
%   if lookformax
%     if this < mx-delta
%       maxtab = [maxtab ; mxpos mx];
%       mn = this; mnpos = x(i);
%       lookformax = 0;
%     end  
%   else
%     if this > mn+delta
%       mintab = [mintab ; mnpos mn];
%       mx = this; mxpos = x(i);
%       lookformax = 1;
%     end
%   end
% end
% %maxtab
% %[mintab]
% maxs=maxtab;
% mins=mintab;
% 
% dt=1/fs;
% t=x;
% %figure(8)
% %plot(maxs(:,1),maxs(:,2),'g*');
% 
% %maximum peak values time in column 1
% peaktime=maxs(:,1);
% %peak maximum values in column 2
% peakval=maxs(:,2);
% 
% %pitch period
% pitchperiods=(diff(peaktime));
% 
% pchdiff=zeros(length(pitchperiods)-1,1);
% 
% %difference b/w successive pitch periods
% for k=1:length(pitchperiods)-1
% pchdiff(k)=(pitchperiods(k)-pitchperiods(k+1));
% end
% 
% avgpchdiff=mean(pchdiff);
% avgpch=mean(pitchperiods);
% 
% jitt =(avgpchdiff/avgpch);