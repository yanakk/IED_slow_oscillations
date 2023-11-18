function [count] = getcoonumbers(IED_marker,SW_marker, winlen)
%getcoonumbers find if IEEG IEDs co-occur with scalp SW in NREM sleep
%   IED_marker,SW_marker, winlen: sec
count = 0;
for i = 1:length(IED_marker)  
    current_time = IED_marker(i);  
    matching_indices = find(SW_marker >= (current_time - winlen) & SW_marker <= (current_time + winlen));  
    count = count + numel(matching_indices);  
end 

end

