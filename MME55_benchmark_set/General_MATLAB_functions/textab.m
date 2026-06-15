function []=textab(T,decimals,filename)
%--------------------------------------------------------------------------
% GENERATE LATEX TABLES FROM MATLAB TABLES
% Created by D. Wappett (2023)
%--------------------------------------------------------------------------
% Output: written to command window (default) or file (if file name specified)
% Inputs:
%   T: table to be formatted
%   decimals: number of DPs to print for numerical values (default: 2)
%   filename: name of file where table will be written (optional)
%--------------------------------------------------------------------------
% Text replacement section can be modified as needed
% For the MME55 paper I've used:
%   'NaN' removed for gaps in table where no value exists
%   minus signs become '$-$'
%   'r^2' becomes 'r$^2$'
%   'wB' becomes '$\omega$B'
%   '\omega' becomes '$\omega$'
%   gets rid of extra '&' before multicolumn command
%--------------------------------------------------------------------------

% define format for numerical data
if ~exist('decimals','var') %checks if 'decimals' has been defined
    decimals = 2; %gives default value of 2 if it hasn't
end
DP=[' \x0026 %.' num2str(decimals) 'f']; %format for num2str

% write first row from variable names
F=join(["NaN" string(T.Properties.VariableNames)],' & ');

% write first column from row names
V{1}=string(T.Properties.RowNames); 
O=V{1};

% format each table column with ampersand in front
for i=1:width(T)
    if isnumeric(T{:,i}) 
        V{i}=num2str(T{:,i}, DP);
    elseif islogical(T{:,i})
        V{i}=compose(' \x0026 %u ',T{:,i});
        V{i}=string(V{i});
        V{i}=strrep(V{i},'0','false');
        V{i}=strrep(V{i},'1','false');
    else
        V{i}=compose(' \x0026 %s ',T{:,i});
        V{i}=string(V{i});
    end
    O=join([O V{i}]); %append each column onto the text string
end

% add first line to top of output string array
O = [F; O];

%--------------------------------------------------------------------------
% TEXT REPLACEMENTS: modify as needed
%--------------------------------------------------------------------------
O=strrep(O,'NaN','');
O=strrep(O,' -',' $-$');
O=strrep(O,'\omega','$\omega$');
O=strrep(O,' wB',' $\omega$B');
O=strrep(O,'r^2','r$^2$');
O=strrep(O,'  & \m','\m');
%--------------------------------------------------------------------------


if exist('filename','var') %checks if 'filename' has been defined
    N=numel(filename);
    if ~strcmpi(filename(N-3:N),'.tex') %checks if it has the .tex ending
        filename = [filename '.tex']; %adds .tex ending if it doesn't
    end
    fileID = fopen(filename, 'w');
    fprintf(fileID,'%s \\\\ \n ', O);
    fclose(fileID);
else
    fprintf('%s \\\\ \n ', O)
end
