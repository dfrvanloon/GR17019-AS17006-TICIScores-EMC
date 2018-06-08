% KTO 2018 - GR17019
% AS17006-TICIScores-EMC
% 05-06-2018

clear all; close all; clc;

%% Import en bewerking TDC
% Import
addpath('C:\Users\Bart\Dropbox\Bart\KT jaar 3\KT3800 KTO\KTO-B\Algoritme perfusie parameters\Oefendata')
tdc = importdata('test_TICs_R0219_8_PROTOCOL.tics');
t_tdc = tdc(:,1);
raw_tissue = tdc(:,2);
raw_aif = tdc(:,3);

% Fitting
f_tissue_fit = fit(t_tdc,raw_tissue,'smoothingspline');
f_aif_fit = fit(t_tdc,raw_aif,'smoothingspline');

t = 0:0.1:max(t_tdc);
y_tissue_fit = feval(f_tissue_fit,t);
y_aif_fit = feval(f_aif_fit,t);

% Normalisatie naar baseline
y_tissue = bf(y_tissue_fit,[0 length(t)],'pchip');
y_tissue(y_tissue<0) = 0;
y_aif = bf(y_aif_fit,[0 length(t)],'pchip');
y_aif(y_aif<0) = 0;
  
%% Plotten grafieken
figure; hold on;
plot(t_tdc,raw_tissue,'r','LineWidth',1)
plot(t,y_tissue_fit,'b','LineWidth',1)
plot(t,y_tissue,'g','LineWidth',1)
title('TDC en bewerkte TDC van het weefsel')
legend('Ruwe TDC data','Functie gefit op data','Functie genormaliseerd naar baseline')
xlabel('Tijd [s]'); ylabel('Dichtheid []')

figure; hold on;
plot(t_tdc,raw_aif,'r','LineWidth',1)
plot(t,y_aif_fit,'b','LineWidth',1)
plot(t,y_aif,'g','LineWidth',1)
title('TDC en bewerkte TDC van de arteriële input')
legend('Ruwe TDC data','Functie gefit op data','Functie genormaliseerd naar baseline')
xlabel('Tijd [s]'); ylabel('Dichtheid []')

%% Berekenen Cu, Ca en R
Ftissue = fft(y_tissue);
Faif = fft(y_aif);
ht = fit(t,ifft(Ftissue./Faif),'cubicinterp');
R = 1 - integrate(ht,t,0);

%% AUC
auc = 1;
data.AUC = auc; 

%% AT
d_tissue = diff(y_tissue)/t(1:length(t)-1)';
i_dtissue = find(d_tissue>0); %cut-off specificeren
at = i_dtissue(1);
data.AT = at;

%% MTT
cbv = trapz(t,y_tissue);
cbf = max(R);
mtt = cbv/cbf;
data.MTT = mtt;

%% PD
pd = max(y_tissue);
i_pd = find(y_tissue==pd);
data.PD = pd;
 
%% TTP
ttp = t(i_pd);
data.TTP = ttp;

%% Export data
data_cell = struct2cell(data);
xlswrite('data_parameters.xlsx',data_cell)
%open('data_parameters.xlsx')
