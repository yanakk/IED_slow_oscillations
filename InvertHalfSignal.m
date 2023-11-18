function [inverted_signal] = InvertHalfSignal(signal,point)
%InvertHalfSignal invert the first half signal to the second half
%   signal: (signal_length,num)

len = length(signal(:,1));

if point >= len/2
    error("***The time point is larger than the half signal***");
end
inverted_signal = signal;
invert_half = signal(1:point,:);
invert_half = flipud(invert_half);
inverted_signal(point+1:2*point,:) = invert_half;
end

