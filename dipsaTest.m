%DYPSA TESTBED

clear all;
close all;

[input,Fs] = audioread('recordings/1.wav');

[gci, goi] = dypsa(input, Fs);

impulseC(gci) = 1;
impulseCT=impulseC';
impulseO(goi)= 1;
impulseOT=impulseO';

%figure()
%plot(input)

%figure()
%plot(input(15000:35000))
%axis('tight');

f1 = figure();
subplot(3,1,1),plot(input((15000:35000),1)),title('Voiced Segment Normal Input Signal'),axis('tight');
subplot(3,1,2),plot(impulseCT((15000:35000),1),'r'),title('Impulse Signal, based on GCI'),axis('tight');
subplot(3,1,3),plot(impulseOT((15000:35000),1),'b'),title('Impulse Signal, based on GOI'),axis('tight');

f2 = figure();
plot(input((15000:35000),1));
hold on
plot(impulseCT((15000:35000),1),'r');
hold on
plot(impulseOT((15000:35000),1),'b'),title('Voiced Overlay Normal Signal');
axis([0 20000 -0.4 0.4]);


N = length(impulseCT);
impulseCTtimeInstances = zeros(1,N);
c=1;
for n = 1:N
    if impulseCT(n) ~= 0
        impulseCTtimeInstances(c) = n;
        c = c+1;
    end
end

impulseCTtimeInstances(impulseCTtimeInstances==0) = [];

f3 = figure();
subplot(2,1,1),plot(1:1:length(impulseCTtimeInstances),impulseCTtimeInstances),title('Impulse Time Instances, Normal GCI');

difference = diff(impulseCTtimeInstances);
sz = 15;
subplot(2,1,2),scatter(1:1:length(difference),difference,sz,difference,'filled'),title('Diff Impulse Time Instances, Normal GCI');

f4 = figure();
boxplot(difference);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%STRESSED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[input,Fs] = audioread('stressed/1.wav');

[gci, goi] = dypsa(input, Fs);

impulseC(gci) = 1;
impulseCT=impulseC';
impulseO(goi)= 1;
impulseOT=impulseO';

%figure()
%plot(input)

%figure()
%plot(input(15000:35000))
%axis('tight');

f1 = figure();
subplot(3,1,1),plot(input((15000:35000),1)),title('Voiced Segment Stressed Input Signal'),axis('tight');
subplot(3,1,2),plot(impulseCT((15000:35000),1),'r'),title('Impulse Signal, based on GCI'),axis('tight');
subplot(3,1,3),plot(impulseOT((15000:35000),1),'b'),title('Impulse Signal, based on GOI'),axis('tight');

f2 = figure();
plot(input((15000:35000),1));
hold on
plot(impulseCT((15000:35000),1),'r');
hold on
plot(impulseOT((15000:35000),1),'b'),title('Voiced Overlay Stressed Signal');
axis([0 20000 -0.4 0.4]);


N = length(impulseCT);
impulseCTtimeInstances = zeros(1,N);
c=1;
for n = 1:N
    if impulseCT(n) ~= 0
        impulseCTtimeInstances(c) = n;
        c = c+1;
    end
end

impulseCTtimeInstances(impulseCTtimeInstances==0) = [];

f3 = figure();
subplot(2,1,1),plot(1:1:length(impulseCTtimeInstances),impulseCTtimeInstances),title('Impulse Time Instances, Stressed GCI');

difference = diff(impulseCTtimeInstances);
sz = 15;
subplot(2,1,2),scatter(1:1:length(difference),difference,sz,difference,'filled'),title('Diff Impulse Time Instances, Stressed GCI');

f4 = figure();
boxplot(difference); 
