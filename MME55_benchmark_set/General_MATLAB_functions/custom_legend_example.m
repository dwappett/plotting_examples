%% Example of custom_legend usage (based on MME55 fig 5/example 8)
% custom legend can go before or after making actual plot, but should go 
% after axes have been updated with PlotSettings so it grabs the right 
% default font size and weight etc

clearvars -except MME55 C

%% Select data

Hfuncs={'B3LYP_D3BJ','B3LYPst_D3BJ','BHLYP_D4','CAM_B3LYP_D4','M06_D4','M062X_D4','MPW1B95_D3BJ','PW6B95_D3BJ','wB97M_V','wB97X_V'}; %'TPSSh_D3BJ'

% Put funcs in MAD order
TH=MME55.stats(Hfuncs,'MAD');
[TH,I]=sortrows(TH,'MAD','descend');
Hfuncs=Hfuncs(I);

% Get deviations
Hdevs=MME55.devs(:,Hfuncs);

%% Make plot

SetPlotDefaults

fig=figure('Units','centimeters','Position',[1 1 35 25]);
ax=axes;

%% Plot violins of hybrid DFA deviations
vH_devs=violinplot(Hdevs,[],'MarkerSize',80,'MedianMarkerSize',100,'Width',0.4,'ViolinColor',[0.9 0.9 0.9],'ViolinAlpha',0.5,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.1,'GroupOrder',Hfuncs);
for i = 1:10
    vH_devs(1,i).ScatterPlot.MarkerFaceColor = 'flat';
    vH_devs(1,i).ScatterPlot.CData = C.R_periodic;
    vH_devs(1,i).ScatterPlot.MarkerEdgeColor = 'k';
    vH_devs(1,i).ViolinPlot.LineWidth = 1.5; %2
end
clear i icons

%% Update various axes settings
set(ax,PlotSettings)
ax.XTickLabel=MME55.funcs{Hfuncs,"Name"};
ax.XLim=[0.3,10.7];
ax.YLim=[-30,40];
ylabel(ax,{'Deviation (kcal/mol)'},'FontSize',30,'fontweight','bold');

%% Add custom legend for the scatter plot colours
[lgd,icons]=custom_legend(unique(MME55.reactions.Reaction,'stable'),C.C10,'s',[]);
scale_lgd_icons(icons,'MarkerEdgeColor','k')

%% Write MADs at bottom of plot
text(ax,1:10,-27*ones([10 1]),num2str(TH.Variables,'\x0028%.1f\x0029'),'HorizontalAlignment','center','fontsize',15,'fontweight','bold') 

%% Save figure
%exportgraphics(fig,'custom_legend_example.pdf','ContentType','vector','BackgroundColor','none');
