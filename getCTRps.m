function [ctr_itcmean] = getCTRps(CTR, fs, all_rec, fl, fh)
%getCTRps To get the average phase synchronization of the control area

channel_num = length(all_rec(1,:));
wlen = 6*fs;      
[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);

for j = 1:1:channel_num
    curr_ctr_s = zeros(wlen,length(CTR));
    curr_signal = all_rec(:,j);
    
    for k = 1:length(CTR)
    cur_t = CTR(k,1)*fs;   % time
    left = int32(cur_t-wlen/2); right = int32(cur_t+wlen/2-1);
    curr_ctr_s(:,k) = curr_signal(left:right,1);
    end
    curr_ctr_s = filtfilt(b1,a1,curr_ctr_s);
    curr_ctr_h = hilbert(curr_ctr_s);
    curr_ctr_pha = angle(curr_ctr_h);
    ctr_pha_all(:,:,j) = curr_ctr_pha;
end

ctr_itc_all = mcoh2(ctr_pha_all,3);
ctr_itcmean = mean(ctr_itc_all(2.5*fs:3.5*fs,:),'all');    % mid 1s

end