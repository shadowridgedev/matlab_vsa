function output = lowpass_butter(signal)
    [B,A] = butter(2,0.55);
    output = filter(B,A,signal);
    