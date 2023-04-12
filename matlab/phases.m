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
un_phase_low=zeros(size(phase_low));
for cxx=1:64
  add=0;
  d=diff(phase(:, cxx));
  for ixx=1:length(phase_low(:, cxx))
    if(ixx>1 && d(ixx-1)>0)
      add=add+2;
    end
    un_phase_low(ixx,cxx)=phase_low(ixx,cxx)-add;
  end
end

if(ntrans > 64)
  un_phase_high=zeros(size(phase_high));
  for cxx=65:ntrans
    add=0;
    d=diff(phase(:, cxx));
    for ixx=1:128
      if(ixx>1 && d(ixx-1)>0)
        add=add+2;
      end
      un_phase_high(ixx,cxx-64)=phase_high(ixx,cxx-64)-add;
    end
  end
end

ph_max_z=ceil(max(max(un_phase_low)))
ph_min_z=floor(min(min(un_phase_low)))


d_un_phase_low=diff(un_phase_low);
if(ntrans > 64)
  d_un_phase_high=diff(un_phase_high);
end
%figure(1)
%hold all
%plot(un_phase_low(:, ch_sel), '-*')
%legend(leg_str)
%
%figure(2)
%hold all
%plot(d_un_phase_low(:, ch_sel)), '-*')
%legend(leg_str)

part_pos=zeros(length(pos_tx), length(pos_ty)).*inf;

figure(3)
subplot(2, 2, 1)
h1=mesh(tx, ty, reshape(un_phase_low(1, :), 8, 8)');
view(view_arg)
zlim([ph_min_z ph_max_z])
subplot(2, 2, 3)
h2=mesh(tx, ty, zeros(8,8));
view(view_arg)

subplot(2, 2, [2, 4])
part_pos(conv_to_axis(pos(1, 1, 1)), conv_to_axis(pos(1, 1, 3)))=pos(1, 1, 2)*pos_fact;
h3=mesh(pos_tx, pos_ty, part_pos, 'Marker','o','MarkerSize',10);
view(view_arg)
part_pos(conv_to_axis(pos(1, 1, 1)), conv_to_axis(pos(1, 1, 3)))=inf;
zlim([0, 100])

pause(0.1)

for ixx=2:10 %steps
  subplot(2, 2, 1)
  h1=mesh(tx, ty, reshape(un_phase_low(ixx, :), 8, 8)');
  view(view_arg)
  zlim([ph_min_z ph_max_z])
  subplot(2, 2, 3)
  h2=mesh(tx, ty, reshape(d_un_phase_low(ixx-1, :), 8, 8)');
  view(view_arg)
  subplot(2, 2, [2, 4])
  part_pos(conv_to_axis(pos(ixx, 1, 1)), conv_to_axis(pos(ixx, 1, 3)))=pos(ixx, 1, 2)*pos_fact;
  h3=mesh(pos_tx, pos_ty, part_pos, 'Marker','o','MarkerSize',10);
  view(view_arg)
  part_pos(conv_to_axis(pos(ixx, 1, 1)), conv_to_axis(pos(ixx, 1, 3)))=inf;
  zlim([0, 100])
  pause(0.1)
end


