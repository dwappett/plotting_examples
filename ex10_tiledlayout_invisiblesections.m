%% Using a tiled layout to have different coloured sections of boxplot
% WARNING: ALL Y AXES MUST BE MANUALLY SET TO THE SAME RANGE!!!
% Also it only looks good with equal numbers of things in each section

clearvars -except MME55 C

%% Select data: top 3 funcs from each rung
rungs={'G','M','H','D'};
for i=1:4
    MADsorted{i}=xstats(MME55,'MAD',rungs{i},'nosmallbasis','bestdisp','sort');
    topthreedevs{i}=MME55.devs(:,MADsorted{i}.Properties.RowNames(end-2:end));
    topthreefuncs{i}=MME55.funcs.Name(MADsorted{i}.Properties.RowNames(end-2:end));
end

%% Make plot using tiled layout

%SetPlotDefaults

fig=figure('Units','centimeters','Position',[1 1 40 30]);
tl=tiledlayout(fig,1,4,"TileSpacing","none");

for i=1:4
    ax{i}=nexttile(tl);

    B{i}=boxplot_custom(topthreedevs{i}{:,:},'fillcolor',C.C4(i,:),'outlier_multiplier',inf);

    set(ax{i},'XLim',[0.5 3.5],'XTickLabel',topthreefuncs{i},'XTickLabelRotation',45)
    set(ax{i},"box","off","YGrid","on",'fontsize',20,'fontweight','bold')
    % DO NOT forget to set all Y axis limits the same
    ylim(ax{i},[-25 65])

    if i>1
        ax{i}.YAxis.Visible = 'off';
    end
end

tl.YLabel.String={'Deviation (kcal/mol)'};
tl.YLabel.FontWeight='bold';
tl.YLabel.FontSize=20;

%% Save figure

%exportgraphics(fig,'Outputs/ex10_tiledlayout_invisiblesections.pdf','ContentType','vector','BackgroundColor','none');
