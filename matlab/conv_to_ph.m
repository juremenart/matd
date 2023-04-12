function ph_norm = conv_to_ph(in_ph, offset=0)
  max_val = 1250;
%  global max_val;

  ph_norm = round(max_val * in_ph / (2))+offset;
  ph_norm = mod(ph_norm, max_val); % wrap
endfunction

