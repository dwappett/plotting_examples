%% Basic boxplot

clearvars -except MME55 C

%% Select data: SCS/SOS DHDFs
F={'DOD_SCAN_D3BJ','DOD_SCAN_D4','revDSD_PBEP86_D3BJ','revDSD_PBEP86_D4','revDOD_PBEP86_D3BJ','revDOD_PBEP86_D4','PWPB95_D3BJ','SOS0_PBE0_2_D3BJ'};
Y = MME55.devs(:,F);
X = categorical(MME55.funcs.Name(F),MME55.funcs.Name(F));

%% Make plot
SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 30 30]);
ax = axes(fig);

B=boxplot_custom(Y{:,:},'linecolor','k','fillcolor','y','outliercolor','r');

PlotSettings.XTickLabel = X;
PlotSettings.XLim=[0.25 numel(X)+0.75];

set(ax,PlotSettings)

ylabel(ax,{'Deviation (kcal/mol)'},'FontSize',25);
title(ax,"SOS/SCS double hybrids",'FontSize',25)

%% Save figure

%exportgraphics(fig,'Outputs/ex3_boxplot_basic.pdf','ContentType','vector','BackgroundColor','none');






