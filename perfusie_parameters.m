% KTO 2018 - GR17019
% AS17006-TICIScores-EMS
% 05-06-2018

%% Import data
data = table2struct(readtable(<%PATIENTDATA>.txt));

for i=1:1:length(data.ptnr)
  %% Import TDC
  tdc = importdata(data.tdc(i)); 
  t_tdc = tdc(:,1);
  y_tdc = tdc(:,2);

  %% AUC
  auc = trapz(t_tdc,y_tdc(:));
  data(i).auc = auc; 
  %nog specificeren tot wanneer bij y()

  %% AT
  d_tdc = diff(tdc);
  i_d_tdc = find(d_tdc>1); %cut-off speficiceren
  at = i_d_tdc(1);
  data(i).at = at;

  %% MTT
  mtt = ;
  data(i).mtt = mtt;

  %% PD
  pd = max(y_tdc);
  data(i).pd = pd;

  %% TTP
  i_pd = find(y_tdc==pd);
  ttp = t_tdc(i_pd);
  data(i).ttp = ttp;
end

%% Export data
data_cell = struct2cell(data);
xlswrite('data_parameters.xlsx',data_cell)

