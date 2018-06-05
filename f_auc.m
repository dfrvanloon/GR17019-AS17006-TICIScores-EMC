function [auc] = f_auc(tdc)
  t_tdc = tdc(:,1);  
  y_tdc = tdc(:,2);
  auc = trapz(t_tdc,y_tdc(:));
end
