function [amp, phase, pos, ntrans, npoints]=read_raw_ani(filename)
  # Raw binary data file produced by simulator is:
  # 1. Integer - number of keys
  # 2. Integer - number of transducers
  # 3. Integer - number of points
  #
  # For each key ('step'):
  #   For each transducer:
  #      4.*k*t Float - amplitude
  #      5.*k*t Float - phase
  #   For each points:
  #      6.*k*p Float pos_x
  #      7.*k*p Float pos_y
  #      8.*k*p Float pos_z

  fid = fopen(filename, 'rb', 'b'); # Specify big-endian

  A=fread(fid, 3, 'int32');

  nkeys=A(1);
  ntrans=A(2);
  npoints=A(3);

  amp=zeros(nkeys, ntrans);
  phase=zeros(nkeys, ntrans);
  pos=zeros(nkeys, npoints, 3);
  for k=1:nkeys
    A=fread(fid, [2, ntrans], 'float');
    amp(k, :)=A(1, :);
    phase(k, :)=A(2, :);

    A=fread(fid, 3, 'float');
    pos(k, :, 1)=A(1, :); # pos_x
    pos(k, :, 2)=A(2, :); # pos_y
    pos(k, :, 3)=A(3, :); # pos_z

  end
  
  fclose(fid);

endfunction
