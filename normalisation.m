% Signal Normalisation Module
% 
%     Author: Alexis Othonos
%     Date: 15.11.2017
%
%     Description: Normalise amplitude, peak detection discard unvoice

% function preprocess()

function output = normalisation(signal, fs)
    %Noise Reduction
    signal = specsub(signal, fs);
    
    %Peak Detection
    
    %Normalisation
    %loudness = integratedLoudness(signal, fs)
    signal = signal - mean(signal);
    
    signal = signal ./ max(signal);
    output = signal;
    
    
