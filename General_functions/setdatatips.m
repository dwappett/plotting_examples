function [] = setdatatips(sc,def,varargin)
%--------------------------------------------------------------------------
% Quickly update data tips for scatter plots
% D. Wappett (2024)
%--------------------------------------------------------------------------
% Inputs:
%   sc = scatter plot
%   def = which default X/Y/C options to include (eg "XYC", "XY", "YC", "Y", etc)
%   any 'Name','Value' argument pairs eg "struc" and array of structure names
%--------------------------------------------------------------------------

%% remove any unspecified data tips

delete=[];
for i=1:length(sc.DataTipTemplate.DataTipRows)
    % if def does not contain first letter of label (X/Y/C), flag it to be removed
    if ~contains(def,sc.DataTipTemplate.DataTipRows(i).Label(1)) 
        delete=[delete i];
    end
end
sc.DataTipTemplate.DataTipRows(delete)=[];

%% go through name/pair arguments
if nargin>2
    for k=1:2:length(varargin)
        row(0.5+k/2)=dataTipTextRow(varargin{k},varargin{k+1});
    end
end

%% add data tips to data tip array
for i=1:length(row)
    sc.DataTipTemplate.DataTipRows(end+1) = row(i);
end
