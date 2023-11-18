function [] = savetoexcel(data,filename, sheet, column)
%savetoexcel save column data to xslx
%   filename:'name.xlsx' sheet: 1  column: 'A'

if exist(filename, 'file') == 0  
    xlswrite(filename, data, sheet, column);  
else  
    old_data = xlsread(filename,sheet,[column,':', column]);
    if isempty(old_data)  
        xlswrite(filename, data, sheet, column);  
    else  
        lastRow = numel(old_data) + 1;  
        xlswrite(filename, data, sheet, sprintf('%s%d', column, lastRow));  
    end  

end

