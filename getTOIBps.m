function [psres] = getTOIBps(SPK_markers,fs, all_rec, fl, fh, isNOZ)
%getTOIBps

channel_num = length(all_rec(1,:));
for j = 1:1:channel_num
    SoI_raw_all(:,:,j) = getSoI(fs,all_rec(:,j),SPK_markers);
end

pret1 = 0.25;              % second, before spike
seg_len = length(SoI_raw_all);
spk_num = length(SoI_raw_all(1,:,1));
total_time = seg_len/fs;
[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);

for j = 1:1:channel_num
    curr_SoI_raw = squeeze(SoI_raw_all(:,:,j));
    if (isNOZ)
        curr_SoI = filtfilt(b1,a1,curr_SoI_raw);
    else
        point = (total_time/2 - 0.2)*fs;         % 0.2s before spk
        curr_SoI_inversed = InvertHalfSignal(curr_SoI_raw,point);
        curr_SoI = filtfilt(b1,a1,curr_SoI_inversed); 
    end
    curr_SoI_h = hilbert(curr_SoI);
    curr_pha = angle(curr_SoI_h);
    pha_all(:,:,j) = curr_pha;
end

itc_all = mcoh2(pha_all,3);
psres = zeros(spk_num, 1);
for i=1:1:spk_num
    cur_itc = itc_all(:, i);
    pos_l1 = total_time/2 - 1 - pret1;
    pos_r1 = total_time/2 - pret1;
    TOI_itc = cur_itc(pos_l1*fs:pos_r1*fs);
    Res_mean = mean(TOI_itc);
    psres(i) = Res_mean;
end

end
