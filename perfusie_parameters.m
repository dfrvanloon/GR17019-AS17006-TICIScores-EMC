% KTO 2018 - GR17019
% AS17006-TICIScores-EMS
% 05-06-2018

%% Import data
all_pt = xlsread();
[data] = importdata(); 
t_data = data(:,1);
y_data = data(:,2);

%% AUC
auc = trapz(t_data,y_data(:));
%nog specificeren tot wanneer bij y()

%% AT
d_data = diff(data);
i_d_data = find(d_data>1); %cut-off speficiceren
at = i_d_data(1);

%% MTT


%% PD
pd = max(y_data);

%% TTP
i_pd = find(y_data==pd);
ttp = t_data(i_pd);

%% Export data
fprintf
