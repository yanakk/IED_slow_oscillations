function [SoI_meanm, pretm] = getPREIEDamp(SPK_markers,fs, rec, fl, fh, isNOZ)
%getPREIEDamp To get the average amplitude and SD of the pre-IED period

[SoI_raw] = getSoI(fs,rec,SPK_markers);

pretm = [1.0:-0.05:0.25];   % 1*16
pretm = pretm';
seg_len = length(SoI_raw);
spk_num = length(SoI_raw(1,:));
total_time = seg_len/fs;
[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);
SoI_meanm = zeros(length(pretm),1);         % save results in all times

if (isNOZ)
    SoI = filtfilt(b1,a1,SoI_raw);
else
    point = (total_time/2 - 0.2)*fs;         % 0.2s before spk
    SoI_inversed = InvertHalfSignal(SoI_raw,point);
    SoI = filtfilt(b1,a1,SoI_inversed);               %filtfilt
end

 SoI_h = hilbert(SoI);
 SoI_amp = abs(SoI_h);
 avr_amp = mean(SoI_amp,2);

for i = 1:1:length(pretm)
    pret = pretm(i);
    pos_l = total_time/2 - 1 - pret;
    pos_r = total_time/2 - pret;
    SoI_mean = mean(avr_amp(pos_l*fs:pos_r*fs));
    SoI_meanm(i) = SoI_mean;
end

end