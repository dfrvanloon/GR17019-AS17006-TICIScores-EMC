function [pd, ttp] = f_pd_ttp(t_cbv,y_cbv)
  pd = max(y_cbv);
  i_pd = find(y_cbv==pd);
  ttp = t_cbv(i_pd);
end
