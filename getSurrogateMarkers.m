function [surrogate_markers] = getSurrogateMarkers(marker_num, time, fs, dis)
%getSurrogateMarkers
%   marker_num: sec; time: sec; fs: Hz; dis: sec

signal_len = fs*time;
marker_temp = []; cnt = 1;
while(length(marker_temp)<marker_num)
    rand = unidrnd(signal_len);        % signal_len - 4000
    randt = rand/fs;
    if randt<= 0                       % <= 2
        continue
    end
    flag = ifsurrogateproper(randt,marker_temp, dis);
    if flag == true
        marker_temp(cnt) = randt;
        cnt = cnt + 1;
    end 
end
surrogate_markers = marker_temp';

end

