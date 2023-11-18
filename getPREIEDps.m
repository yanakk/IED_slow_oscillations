function [itc_meanm, pretm] = getPREIEDps(SPK_markers,fs, all_rec, fl, fh, isNOZ)
%getPREIEDps To get the average phase syncrhonization of the pre-IED period
%   此处提供详细说明

channel_num = length(all_rec(1,:));
for j = 1:1:channel_num
    SoI_raw_all(:,:,j) = getSoI(fs,all_rec(:,j),SPK_markers);
end

pretm = [1.0:-0.05:0.25];   % 1*16
pretm = pretm';
seg_len = length(SoI_raw_all);
spk_num = length(SoI_raw_all(1,:,1));
total_time = seg_len/fs;
[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);

itc_meanm = zeros(length(pretm),1);         % save results in all times

% inversion; not needed if NOZ
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

for i = 1:1:length(pretm)
    pret = pretm(i);
    pos_l = total_time/2 - 1 - pret;
    pos_r = total_time/2 - pret;
    itc_mean = mean(itc_all(pos_l*fs:pos_r*fs,:),'all');
    itc_meanm(i) = itc_mean;
end

end