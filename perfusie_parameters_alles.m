% KTO 2018 - GR17019
% AS17006-TICIScores-EMC
% 05-06-2018

clear all; close all; clc;

%% Import data
addpath('D:')                                                   % Locatie van de data toevoegen aan het pad
data = table2struct(readtable('data.xlsx'));                    % Inlezen van de datafile met alle patiëntdata

%% Bepalen parameters
[N,~] = size(data);                                             % Bepalen van de hoeveelheid patiënten in de datafile
for i=1:1:N
  
  %% Import en bewerking TIC  
  % Import
  addpath(D:\TICs);                                             % Locatie van de .tics files toevoegen aan het pad
  filename = dir([data(i).Bestandsnaam,'*']);                   % Naam van de .tics file achterhalen, deze begint met de naam van het .dcm bestand
  tdc = importdata(filename.name);                              % Importeren van de tics file van de patiënt
  t_tdc = tdc(:,1);                                             % Tijdswaarden van de TIC
  raw_tissue = tdc(:,2);                                        % waarden van het weefsel 
  raw_aif = tdc(:,3);                                           % waarden van de arteriële input functie (AIF)

  % Fitting
  f_tissue_fit = fit(t_tdc,raw_tissue,'smoothingspline');       % Fit op TIC met Smoothing Spline fitting, uitkomst is een functie
  f_aif_fit = fit(t_tdc,raw_aif,'smoothingspline');             % Hetzelfde voor de AIF
  
  t = 0:0.1:max(t_tdc);                                         % Zelf bepaalde, vaste tijdsvector
  y_tissue_fit = feval(f_tissue_fit,t);                         % Tijdsvector wordt gebruikt om de Y-waarden van de gefitte functie te verkrijgen
  y_aif_fit = feval(f_aif_fit,t);                               % Hetzelfde voor de AIF

  % Normalisatie naar baseline
  y_tissue = bf(y_tissue_fit,[0 length(t)],'pchip');            % Grafieken worden naar baseline gebracht m.b.v. een script die beschikbaar was via de File Exchange
  y_tissue(y_tissue<0) = 0;                                     % van MATLAB. Op basis van de eerste en de laatste waarde van de grafiek wordt er een functie bepaald
  y_aif = bf(y_aif_fit,[0 length(t)],'pchip');                  % Die deze punten en daarmee de hele grafiek weer naar 0 brengt.
  y_aif(y_aif<0) = 0;                                           % Negatieve waarden a.g.v. de normalisatie worden op 0 gezet.

  %% Berekenen Cu, Ca en R
  Ftissue = fft(y_tissue);                                      % Fourier transformatie van de gefitte, genormaliseerde grafiek
  Faif = fft(y_aif);                                            % Hetzelfde voor de AIF
  ht = fit(t,ifft(Ftissue./Faif),'cubicinterp');                % Deconvolutie om de transferfunctie van Y_tissue(t) = AIF(t) (conv) H(t) te bepalen.
                                                                % Incl. inverse Fourier en kubische interpolatie om een functie te maken.
  R = 1 - integrate(ht,t,0);                                    % Bepaling van de residufunctie R(t) door integratie van 0 naar alle waarden van t

  %% AUC
  auc = 1;
  data(i).AUC = auc;                                            % Inschrijven van de AUC in de datafile bij de patiënt

  %% AT
  d_tissue = diff(y_tissue)/t(1:length(t)-1)';                  % Afgeleide van de weefsel-TIC
  i_dtissue = find(d_tissue>0);                                 % Indices van de hellingen groter dan de cut-off
  at = t(i_dtissue(1));                                         % Eerste tijdstip waarop de helling hoger is dan de cut-off, het moment waarop de bolus in het weefsel is aangekomen (AT)                             
  data(i).AT = at;                                              % Inschrijven van de arrival time in de datafile bij de patiënt 

  %% MTT
  cbv = trapz(t,y_tissue);                                      % AUC van de weefsel-TIC. Dit is het cerebral blood volume (CBV)
  cbf = max(R);                                                 % Hoogste punt van de residufunctie. Dit is de cerebral blood flow (CBF)
  mtt = cbv/cbf;                                                % De mean transit time is het CBV/CBF
  data(i).MTT = mtt;                                            % Inschrijven van de MTT in de datafile bij de patiënt

  %% PD
  pd = max(y_tissue);                                           % De peak density (PD) is de maximale dichtheid in het weefsel, dus de piek van de weefsel-TIC
  data(i).PD = pd;                                              % Inschrijven van de PD in de datafile bij de patiënt
  
  %% TTP
  i_pd = find(y_tissue==pd);                                    % De index van de PD waarde
  ttp = t(i_pd);                                                % De time to peak (TTP) is de t behorende bij de PD
  data(i).TTP = ttp;                                            % Inschrijven van de TTP in de datafile bij de patiënt
  
end

%% Export data
data_cell = struct2cell(data);                                  % De datafile omschrijven van struct naar cell formaat
xlswrite('data_parameters.xlsx',data_cell')                     % Schrijven van een Excelbestand met de datafile als cell
%open('data_parameters.xlsx')                                    

% data_table = struct2table(data);                              
% writetable(data_table,'data_parameters')
