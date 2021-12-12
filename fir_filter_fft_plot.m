%reference to matlab documentation FrequencyAnalysisExample, 
%specifically the equation for F and plotting in helperFrequencyAnalysisPlot1
%https://www.mathworks.com/help/signal/ug/practical-introduction-to-time-frequency-analysis.html

%read in system Verilog file input and output values
results(:,{'x_in','y_out'}) = readtable('results.csv');

%%
Fs = 48000; %divided clock cycle
y = results.y_out; %output

ylen = length(y); %length of output
Y = fft(y,ylen); %fourier transform values
F = ((0:1/ylen:1-1/ylen)*Fs).'; %use sampling frequency to convert to frequency
Ymag = abs(Y); %magnitude of ff

figure(1) %impulse response with raw y_out values
stem(y);
title('FIR filter Impulse Response')
xlabel('Time Index (Fs = 48000kHz)')
ylabel('Amplitude')

figure(2) %frequency response with processed fft y_out values
plot(F(1:ylen/2)/1e3,20*log10(Ymag(1:ylen/2)));
title('FIR Filter Frequency Response')
xlabel('Frequency in kHz')
ylabel('dB')
grid on;