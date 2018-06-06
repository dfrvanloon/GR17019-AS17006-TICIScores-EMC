function [pd, ttp] = f_pd_ttp(tdc)
  t_tdc = tdc(:,1);
  y_tdc = tdc(:,2);
  pd = max(y_tdc);
  i_pd = find(y_tdc==pd);
  ttp = t_tdc(i_pd);
end
