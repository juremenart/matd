function [amp, phase, ntrans]=read_raw_csv(filename)
  # CSV binary data file produced by simulator is:

  t=load(filename);

  ntrans=length(t(:, 1));

  amp=zeros(1, ntrans);
  phase=t(:, end)';

endfunction
