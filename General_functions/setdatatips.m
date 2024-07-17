function [] = setdatatips(sc,def,varargin)
%--------------------------------------------------------------------------
% Quickly update data tips for scatter plots
% D. Wappett (2024)
%--------------------------------------------------------------------------
% Inputs:
%   sc = scatter plot
%   def = which default X/Y/C/S options to include (eg "XYC", "XY", "YC", "YS", etc)
%   any 'Name','Value' argument pairs eg "struc" and array of structure names
%--------------------------------------------------------------------------

%% define initial number of data tip rows
N=length(sc.DataTipTemplate.DataTipRows);

%% add new data tips from name/pair arguments
if nargin>2
    for k=1:2:length(varargin)
        row(0.5+k/2)=dataTipTextRow(varargin{k},varargin{k+1});
    end

    for i=1:length(row)
    sc.DataTipTemplate.DataTipRows(end+1) = row(i);
    end
end

%% delete unwanted data tips
% done at the end because datatiprows can't be empty so you need to add the
% new ones first if you want to delete all the default ones

delete=[];

if isempty(def)
    delete=1:N;
else
    for i=1:N
        % if def does not contain first letter of label (X/Y/C/S), flag it to be removed
        if ~contains(def,sc.DataTipTemplate.DataTipRows(i).Label(1)) 
            delete=[delete i];
        end
    end
end

sc.DataTipTemplate.DataTipRows(delete)=[];
