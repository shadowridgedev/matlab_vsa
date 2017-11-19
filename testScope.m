
[input Fs] = audioread('normal/1.wav');


scope = dsp.SpectrumAnalyzer;
scope.SampleRate = Fs;
scope.SpectralAverages = 1;
scope.PlotAsTwoSidedSpectrum = false;
scope.RBWSource = 'Auto';
scope.PowerUnits = 'dBW';


scope(input)