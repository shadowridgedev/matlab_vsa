% Running Windowed Average
% 
%     Author: Alexis Othonos
%     Date: 15.11.2017
%
%     Description: Finds the windowed average of the signal according to
%     given window size


function output = median_filter(input, fs, window_width)
    
    
    len = length(input);
    output = zeros(len ,1);
    %Find window size in steps-discrete period (Nw)
    Nw = floor(window_width*fs);
    
    %Set initial Nw/2 and final Nw/2 values of the avg vector as the first
    %and last value found by the window respectively.
    output(1:1+floor(Nw/2)) = mean(abs(input(1:1+Nw)));
    output(len - ceil(Nw/2): len) = mean(abs(input(len-Nw:len)));
    %Start loop from beginning of signal, until the right edge 
    %of the window reaches the final signal value
    for n = 1:(len - Nw)
        output(n+floor(Nw/2)) =  mean(abs(input(n:n+Nw)));
    end
    
    
    
    