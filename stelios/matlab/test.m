clear all;
clc;

Stressed_Male_fos = dlmread ('StressedMale_fos.m'); 
Stressed_Female_fos = dlmread ('StressedFemale_fos.m'); 
Normal_Male_fos = dlmread ('NormalMale_fos.m'); 
Normal_Female_fos = dlmread ('NormalFemale_fos.m');

M_SvsNonS=ranksum([Stressed_Male_fos],[Normal_Male_fos]); % Male Stressed vs Non Stressed

F_SvsNonS=ranksum([Stressed_Female_fos],[Normal_Female_fos]);% Female Stressed vs Non Stressed

% Calculation of mean values of the fundamental Frequencies
SM_mean_fo = mean(Stressed_Male_fos);
NM_mean_fo = mean(Normal_Male_fos);
SF_mean_fo = mean(Stressed_Female_fos);
NF_mean_fo = mean(Normal_Female_fos);

% Calculation of mean values of the fundamental Frequencies
SM_max_fo = max(Stressed_Male_fos);
NM_max_fo = max(Normal_Male_fos);
SF_max_fo = max(Stressed_Female_fos);
NF_max_fo = max(Normal_Female_fos);

% Calculation of mean values of the fundamental Frequencies
SM_min_fo = min(Stressed_Male_fos);
NM_min_fo = min(Normal_Male_fos);
SF_min_fo = min(Stressed_Female_fos);
NF_min_fo = min(Normal_Female_fos);







