% KTO 2018 - GR17019
% AS17006-TICIScores-EMC
% 05-06-2018

%% Import data
data = table2struct(readtable(<%PATIENTDATA>.txt));

%% Bepalen parameters
for i=1:1:length(data.Patientnummer)
  % Import TDC
  addpath(data(i).PadTDC);
  tdc = importdata(data(i).TDC);
  
  % Normalisatie TDC

  % AUC
  auc = f_auc(tdc);
  data(i).AUC = auc; 

  % AT
  at = f_at(tdc);
  data(i).AT = at;

  % MTT
  mtt = f_mtt(tdc);
  data(i).MTT = mtt;

  % PD en TTP
  [pd, ttp] = f_pd_ttp(tdc);
  data(i).PD = pd;
  data(i).TTP = ttp;
end

%% Export data
data_cell = struct2cell(data);
xlswrite('data_parameters.xlsx',data_cell)

