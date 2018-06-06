function [auc] = f_at(Ca)
  dCa = diff(Ca);
  i_dCa = find(dCa>0); %cut-off specificeren
  at = i_dCa(1);
end
