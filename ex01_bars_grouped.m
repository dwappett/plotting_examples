%% Grouped bar chart
% Simple bar chart with clustered bars
% Can be used for single bars as well when Y is just a single column

clearvars -except MME55 C

%% Select data

% Select hybrid functionals from MAD table
Y = MME55.BarPlots.MAPDgrouped(MME55.BarPlots.MAPDgrouped.RungNum==3,{'Plain','D3','D4','V'});
% Sort by D3 MADs
Y = sortrows(Y,"D3","descend");
% Define X values from table row names
X = Y.Properties.RowNames;

%% Make plot
SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 50 30]);
ax = axes(fig);

B=bar(X,Y{:,:},0.8,"grouped",'FaceColor','flat','EdgeColor','none','LineWidth',2,'CData',C.C4(1,:));
B(2).CData=C.C4(2,:);
B(3).CData=C.C4(3,:);
B(4).CData=C.C4(4,:);

set(ax,PlotSettings)
ylabel(ax,{'MAPD (%)'},'FontSize',25,'fontweight','bold');
title(ax,"All variants of each hybrid DFA ordered by decreasing D3 MAPD",'FontSize',25,'fontweight','bold')


lgd=legend(ax,{'None','DFT-D3','DFT-D4','VV10'},"FontSize",20,'Location','northeast','Orientation','vertical');
title(lgd,'Dispersion correction:')

%exportgraphics(fig,'Outputs/ex1_bars_grouped.pdf','ContentType','vector','BackgroundColor','none');
