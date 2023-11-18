function [zscored_ampres] = zscoredamp(SPK_markers,fs, rec, fl, fh, isNOZ)
%zscoredamp z-socred pre-IED amplitudes (0.25-1.25s against 1.00-2.00s)

[SoI_raw] = getSoI(fs,rec,SPK_markers);         % 12s signal. TOI-A

pret1 = 0.25;              % second, before spike
pret2 = 1.00;              % baseline
seg_len = length(SoI_raw);
spk_num = length(SoI_raw(1,:));
total_time = seg_len/fs;
[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);

if (isNOZ)
    SoI = filtfilt(b1,a1,SoI_raw);
else
    point = (total_time/2 - 0.2)*fs;         % 0.2s before spk
    SoI_inversed = InvertHalfSignal(SoI_raw,point);
    SoI = filtfilt(b1,a1,SoI_inversed);               %filtfilt
end
 SoI_h = hilbert(SoI);
 SoI_amp = abs(SoI_h);

 zscored_ampres = zeros(spk_num, 1);
 for i=1:1:spk_num
    cur_amp = SoI_amp(:, i);
    pos_l1 = total_time/2 - 1 - pret1;
    pos_r1 = total_time/2 - pret1;
    pos_l2 = total_time/2 - 1 - pret2;
    pos_r2 = total_time/2 - pret2;
    TOI_amp = cur_amp(pos_l1*fs:pos_r1*fs);
    Ctr_amp = cur_amp(pos_l2*fs:pos_r2*fs);
    Ctr_mean = mean(Ctr_amp); Ctr_sd = std(Ctr_amp);
    % z-scored
    Res = (TOI_amp - Ctr_mean) ./ Ctr_sd;
    Res_mean = mean(Res);
    zscored_ampres(i) = Res_mean;
 end
 
end

