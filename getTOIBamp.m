function [ampres] = getTOIBamp(SPK_markers,fs, rec, fl, fh, isNOZ)
%getTOIBamp

[SoI_raw] = getSoI(fs,rec,SPK_markers);         % 12s signal. TOI-A

pret1 = 0.25;              % second, before spike
seg_len = length(SoI_raw);
spk_num = length(SoI_raw(1,:));
total_time = seg_len/fs;
[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);
% inversion; may not needed if NOZ
if (isNOZ)
    SoI = filtfilt(b1,a1,SoI_raw);
else
    point = (total_time/2 - 0.2)*fs;         % 0.2s before spk
    SoI_inversed = InvertHalfSignal(SoI_raw,point);
    SoI = filtfilt(b1,a1,SoI_inversed);               %filtfilt
end
 SoI_h = hilbert(SoI);
 SoI_amp = abs(SoI_h);

ampres = zeros(spk_num, 1);
 for i=1:1:spk_num
    cur_amp = SoI_amp(:, i);
    pos_l1 = total_time/2 - 1 - pret1;          % 1s segement, TOI-B
    pos_r1 = total_time/2 - pret1;
    TOI_amp = cur_amp(pos_l1*fs:pos_r1*fs);
    Res_mean = mean(TOI_amp);
    ampres(i) = Res_mean;
 end
end
