function [ctr_ampmean, ctr_sd_amp] = getCTRamp(CTR,fs, rec, fl, fh)
%getCTRamp To get the average amplitude and SD of the control area

signal = rec;
wlen = 6*fs;        % 

ctr_s = zeros(wlen,length(CTR));
% cut
for i = 1:length(CTR)
    cur_t = CTR(i,1)*fs;   % current time marker 
    left = int32(cur_t-wlen/2); right = int32(cur_t+wlen/2-1);
    ctr_s(:,i) = signal(left:right,1);
end

[b1, a1] = butter(2, [fl*2/fs,fh*2/fs]);
ctr_s = filtfilt(b1,a1,ctr_s);

ctr_h = hilbert(ctr_s);
ctr_amp = abs(ctr_h);
ctr_avr_amp = mean(ctr_amp,2);
ctr_sd_amp = std(ctr_amp,0,2);
ctr_ampmean = mean(ctr_avr_amp(2.5*fs:3.5*fs));    % mid 1s

end