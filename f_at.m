function [auc] = f_at(tdc)
  d_tdc = diff(tdc);
  i_d_tdc = find(d_tdc>1); %cut-off speficiceren
  at = i_d_tdc(1);
end
