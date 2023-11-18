% Extract markers of each channel from the results output by Delphos.
% yhy 2021/12/2

all_label = results.labels;
markers = results.markers;
allSPK = struct;
allSPK.labels = all_label;
for i = 1:1:length(all_label)
    expr = [ 'field' num2str(i) ' = all_label{i};' 'value' num2str(i)  '= [];'];
    eval(expr);
end

for j = 1:1:length(markers)
    pos = markers(j).position;
    spike_label = markers(j).channels{1};
    for i = 1:1:length(all_label)
        if (isequal(spike_label, all_label{i}))
            eval(['value' num2str(i)  '(end+1) = pos;']);
            break;
        end
    end  
end

for i = 1:1:length(all_label)
    eval(['value' num2str(i) '= sort(value' num2str(i) ''',''ascend'');']);
    eval(['allSPK.field' num2str(i) ' = value' num2str(i) ';']);
end
% save('allSPKpos.mat',Name_Markers) ;