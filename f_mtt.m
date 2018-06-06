function [mtt] = f_mtt(tdc)
  cbv = trapz(t_Ca,y_Ca);
  cbf = max(R);
  mtt = cbv/cbf;
end
