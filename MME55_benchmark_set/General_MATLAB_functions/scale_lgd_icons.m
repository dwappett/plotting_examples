function [] = scale_lgd_icons(icons,varargin)
%--------------------------------------------------------------------------
% Scale legend icons
% D. Wappett (2024)
%--------------------------------------------------------------------------
% - default scale factor is 0.8 of text size
% - optional arguments are 'ScaleFactor'+value if you want a different size,
%   also 'MarkerEdgeColor'+value and 'LineWidth'+value for icon outlines
%--------------------------------------------------------------------------

%% check for optional arguments

idx=find(strcmpi(varargin, 'ScaleFactor'));
if ~isempty(idx)
    scale=varargin{idx+1};
else
    scale=0.8;
end

idx=find(strcmpi(varargin, 'MarkerEdgeColor'));
if ~isempty(idx)
    col=varargin{idx+1};
end

idx=find(strcmpi(varargin, 'LineWidth'));
if ~isempty(idx)
    lw=varargin{idx+1};
end

%% modify the icons

N=numel(icons);
% first N elements of object icons are text and last N are the actual graphics
for i=1+N/2:N
    icons(i).Children.MarkerSize = scale*icons(1).FontSize;
    if exist('col','var')
        icons(i).Children.MarkerEdgeColor = col;
    end
    if exist('lw','var')
        icons(i).Children.LineWidth = lw;
    end
end




