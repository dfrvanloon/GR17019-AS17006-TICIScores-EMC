% KTO 2018 - GR17019
% AS17006-TICIScores-EMC
% 05-06-2018

clear all; close all; clc;

addpath('E:')
data = table2struct(readtable('data_geincludeerd.xlsx'));

%% Import en bewerking TDC
% Import
pt = ;                       % Rijnummer uit de file behorende bij een patiënt
addpath('E:\TICs')                 
filename = dir([data(pt).Bestandsnaam,'*']); 
tdc = importdata(filename.name);              
t_tdc = tdc(:,1);
raw_tissue = tdc(:,2);
raw_aif = tdc(:,3);

% Fitting
t = 0:0.1:max(t_tdc);
f_tissue_fit = pchip(t_tdc,raw_tissue,t);
f_aif_fit = pchip(t_tdc,raw_aif,t);

% Normalisatie naar baseline
y_tissue = y_tissue_fit - y_tissue_fit(1);
y_aif = y_aif_fit - y_aif_fit(1);
  
%% Plotten grafieken
figure; 
TDC_plot = subplot(1,2,1); hold on;
plot(t_tdc,raw_tissue,'r','LineWidth',1)
plot(t,y_tissue_fit,'b','LineWidth',1)
plot(t,y_tissue,'g','LineWidth',1)
title('TDC en bewerkte TDC van het weefsel')
legend('Ruwe TDC data','Functie gefit op data','Functie genormaliseerd naar baseline')
xlabel('Tijd [s]'); ylabel('Dichtheid []')

AIF_plot = subplot(1,2,2); hold on;
plot(t_tdc,raw_aif,'r','LineWidth',1)
plot(t,y_aif_fit,'b','LineWidth',1)
plot(t,y_aif,'g','LineWidth',1)
title('TDC en bewerkte TDC van de arteriële input')
legend('Ruwe TDC data','Functie gefit op data','Functie genormaliseerd naar baseline')
xlabel('Tijd [s]'); ylabel('Dichtheid []')

linkaxes([TDC_plot,AIF_plot],'y')

%% Berekenen Cu, Ca en R
Ftissue = fft(y_tissue);
Faif = fft(y_aif);
ht = fit(t,ifft(Ftissue./Faif),'cubicinterp');
R = 1 - integrate(ht,t,0);

%% AUC
auc = 1;
data(pt).AUC = auc; 

%% AT
d_tissue = diff(y_tissue)/t(1:length(t)-1)';
i_dtissue = find(d_tissue>0); %cut-off specificeren
at = i_dtissue(1);
data(pt).AT = at;

%% MTT
cbv = trapz(t,y_tissue);
cbf = max(R);
mtt = cbv/cbf;
data(pt).MTT = mtt;

%% PD
pd = max(y_tissue);
i_pd = find(y_tissue==pd);
data(pt).PD = pd;
 
%% TTP
ttp = t(i_pd);
data.TTP = ttp;

%% Export data
data_cell = struct2cell(data);
xlswrite('data_parameters.xlsx',data_cell)
%open('data_parameters.xlsx')
