% KTO 2018 - GR17019
% AS17006-TICIScores-EMS
% 05-06-2018

%% Import data
data = table2struct(readtable(<%PATIENTDATA>.txt));

%% Bepalen parameters
for i=1:1:length(data.Patientnummer)
  % Import TDC
  addpath(data(i).PadTDC);
  tdc = importdata(data(i).TDC);
  t_tdc = tdc(:,1);
  y_tdc = tdc(:,2);
  
  % Normalisatie TDC

  % AUC
  auc = trapz(t_tdc,y_tdc(:));
  data(i).AUC = auc; 
  %nog specificeren tot wanneer bij y()

  % AT
  d_tdc = diff(tdc);
  i_d_tdc = find(d_tdc>1); %cut-off speficiceren
  at = i_d_tdc(1);
  data(i).AT = at;

  % MTT
  mtt = ;
  data(i).MTT = mtt;

  % PD
  pd = max(y_tdc);
  data(i).PD = pd;

  % TTP
  i_pd = find(y_tdc==pd);
  ttp = t_tdc(i_pd);
  data(i).TTP = ttp;
end

%% Export data
data_cell = struct2cell(data);
xlswrite('data_parameters.xlsx',data_cell)

