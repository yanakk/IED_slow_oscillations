function [res] = ifsurrogateproper(randt,Markers, dis)
%ifsurrogateproper Identify if the random time is in the proper region
%dis: minimum distance between another marker (sec)

markers_num = length(Markers);
res = true;

if res == true && markers_num>0
    for j= 1:1:markers_num
        tempp = abs(Markers(j) - randt);
        if tempp <= dis
            res = false;
            break;
        end
    end
end

end
