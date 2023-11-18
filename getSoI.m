function [SoI] = getSoI(fs,signal,SPK)
%getSoI get segments of interests from a signal, according to spikes
%   fs: sampling frequency; signal: one EEG signal, (data_len,1)
%   SPK: all locations of spike, (spk_num,1)
%   SoI: all segments of interests, (2*ww,spk_num)

% define constants
w = 6;                          % s, half of width of the time window
ww = w*fs;
spk_num = length(SPK);          % number of spike in one channel
data_len = length(signal);

% channel_num = length(SPK(1,:));
% SoI = zeros(spk_num, 2*ww, channel_num);
SoI = zeros(2*ww,spk_num);

% cut
for i = 1:spk_num
    cur_t = SPK(i,1)*fs;   % time
    if cur_t<ww+1
        disp("***The FIRST time point is less than the time window length!***");
        continue;
    elseif  data_len - cur_t<ww+1
        disp("***The LAST time point is less than the time window length!***");
        continue;
    end
    left = int32(cur_t-ww); right = int32(cur_t+ww-1);
    SoI(:,i) = signal(left:right,1);
end
SoI(:,all(SoI==0,1))= [];   % delete blank column

end