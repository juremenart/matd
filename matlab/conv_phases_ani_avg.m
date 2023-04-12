% works with CSV
close
clear all
clc

[amp, phase, pos, ntrans, npoints]=read_raw_ani('array_info/single_8x8/test2_yz.ani');
out_file='../data/avg_diff/yz.txt'

steps=length(phase(:, 1))

acc_phase=zeros(1, length(phase(1, :)));
acc_cnt=0;

for ixx=2:steps
  for jxx=1:ntrans
    phase_d=conv_to_ph(phase(ixx, jxx))-conv_to_ph(phase(ixx-1, jxx));
    if(phase_d > 1000)
      phase_d -= 1250;
    end
    if(phase_d < -1000)
      phase_d += 1250;
    end
    acc_phase(jxx) += phase_d;
           
    end
  acc_cnt += 1;
end

for jxx=1:ntrans
  acc_phase(jxx) = round(acc_phase(jxx) / acc_cnt);
end

printf("Differential matrix:\n");
for jxx=1:ntrans
  printf("%02d ", acc_phase(jxx));
  if(mod(jxx, 8) == 0)
    printf("\n");
  end
end
printf("\n");

fo=fopen(out_file, "w");
for jxx=1:ntrans
  fprintf(fo, "%02d ", acc_phase(jxx));
  if(mod(jxx, 8) == 0)
    fprintf(fo, "\n");
  end
end
fclose(fo);
