%test main
clc;
clear all;
[signal_stereo,fs] = audioread('recordings/numbers_01-1_norm.wav');
%sound(signal,fs);

signal = signal_stereo(:,1);

%[signal,fs] = audioread('recordings/ucy_samples/stressed/fem_degree.wav')


[voice,avg] = signal_preprocess(signal,fs );
plot(signal), hold on, plot(voice),hold on, plot(avg);

% f0 = figure();
% subplot(411),plot(signal), hold on, plot(voice1);
% subplot(412),plot(signal), hold on, plot(voice2);
% subplot(413),plot(signal), hold on, plot(voice3);
% subplot(414),plot(signal), hold on, plot(voice4);
%subplot(212),plot(signal);

% f1 = figure();
% subplot(411),plot(avg1);grid on;
% subplot(412),plot(avg2);grid on;
% subplot(413),plot(avg3);grid on;
% subplot(414),plot(avg4);grid on;



