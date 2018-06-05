function [pd, ttp] = f_pd_ttp(tdc)
  y_tdc = tdc(:,2);
  pd = max(y_tdc);
  i_pd = find(y_tdc==pd);
  ttp = t_tdc(i_pd);
end
