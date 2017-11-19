% Signal Preprossessing Module
% 
%     Author: Alexis Othonos
%     Date: 15.11.2017
%
%     Description: Find Voice and Un-Voice Regions by passing a 2-stage running
%     windowed average filter. The first stage will average the power of the signal 
%     while the second filter will smooth out the avg with a smaller window
% 

function [output1, output2] = signal_preprocess(input, fs, window_length)
    %Window size default value
    if nargin == 3
        window_size = window_length;
    elseif nargin == 2
            window_size = 0.01;
    end
             
    %Threshold: (default = 30%)
    percentage = 0.25;
    %Normalise signal
    signal = normalisation(input, fs);
    %Window period: 50msec
    %Start loop from beginning of signal, until the right edge 
    %of the window reaches the final signal value
    
    len = length(signal);

    %Voice-Unvoice vector: 
        %1 for voice
        %0 for unvoice

    %Find windowed average
    
    
    avg = window_average(signal, fs, window_size);
    avg = window_average(avg, fs, window_size);
    
    avg_max = max(avg);
    
    voice = zeros(len,1);
    threshold = avg_max*percentage;

    for n = 1:len
        if avg(n) >= threshold
            voice(n) = 1;
        end
    end
    voice = on_off(voice);
    avg = avg ./ max(avg);   
    output1 = voice;
    output2 = avg;
    
    
    
