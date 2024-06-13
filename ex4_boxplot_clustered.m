%% Boxplots in clusters (using grouping function of boxplot_custom)

clearvars -except MME55 C

%% Select data: basis set comparisons, D4 only
%Y = [xdevs(MME55,'func','B3LYP','D4') xdevs(MME55,'func','M06','D4') xdevs(MME55,'func','PWPB95','D4') xdevs(MME55,'func','\omegaB2PLYP','D4')];
Y_DZ = xdevs(MME55,'DZ','D4');
Y_TZ = xdevs(MME55,'TZ','D4');
Y_QZ = MME55.devs{:,{'B3LYP_D4','M06_D4','PWPB95_D4','wB2PLYP_D4'}};

%% Make plot
SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 30 30]);
ax = axes(fig);

B=boxplot_custom(Y_DZ,Y_TZ,Y_QZ,'mode',3,'list_legends',{'def2-SVP','def2-TZVPP','def2-QZVPP'},'outlier_multiplier',inf);

PlotSettings.XTickLabel = {'B3LYP-D4','M06-D4','PWPB95-D4','\omegaB2PLYP-D4'};
PlotSettings.XTickLabelRotation=0;
PlotSettings.XLim=[0.25 4.75];
PlotSettings.YLim=[-25 55];

set(ax,PlotSettings)

ylabel(ax,{'Deviation (kcal/mol)'},'FontSize',25,'fontweight','bold');

%% Save figure

%exportgraphics(fig,'Outputs/ex4_boxplot_clustered.pdf','ContentType','vector','BackgroundColor','none');