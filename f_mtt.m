function [mtt] = f_mtt(t_Ca,y_Ca,R)
  cbv = trapz(t_Ca,y_Ca);
  cbf = max(R);
  mtt = cbv/cbf;
end
