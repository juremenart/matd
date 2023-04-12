close
clear all
clc

%[amp, phase, pos, ntrans, npoints]=read_raw('array_info/dual_8x8/sin_pos_y.ani');
%[amp, phase, pos, ntrans, npoints]=read_raw('array_info/dual_8x8/dual_pos_z.ani');
%[amp, phase, pos, ntrans, npoints]=read_raw_ani('array_info/dual_8x8/dual_circle_x_z.ani');
#[amp, phase, pos, ntrans, npoints]=read_raw('array_info/dual_8x8/dual_pos_y.ani');
#[amp, phase, pos, ntrans, npoints]=read_raw('array_info/dual_8x8/dual_phase_walk.ani');
[amp, phase, pos, ntrans, npoints]=read_raw_ani('array_info/dual_8x8_proto2/pos_xyz_move.ani');

# Position coordination (use conv_to_axis(pos) to convert)
global pos_tx=pos_ty=linspace(1, 8, 64);
# Position X/Z correction (X/Z goes from -0.03 to +0.03 while Y goes from 0 to 0.6)
global pos_mag=1000; # Position factor (-0.03 - 0.03 is really converted to -30 to +30)
global pos_max=30; # Max is -.03 * 1000 = +/- 30
# This goes only for X/Z, Y is calculated only with * pos_mag
global pos_fact=pos_mag * (length(pos_tx)/2) / pos_max



function a_coor = conv_to_axis(pos)
  global pos_fact;
  global pos_tx;
  
  a_coor = round((pos * pos_fact)+length(pos_tx)/2);
  if(a_coor < 1)
    a_coor = 1;
  endif
  
endfunction

# Select 2D/3D views or have special angles (see view() documentation)
view_arg=2

ch_sel=1:32;

phase(1, ch_sel)

steps=length(phase(:, 1));

leg_str=num2str(ch_sel');

tx=ty=linspace(1, 8, 8);

phase_low=phase(:, 1:64);
if(ntrans == 125)
  phase_high=phase(:, 65:125);
end


% Unwrap phase - looong manual work
