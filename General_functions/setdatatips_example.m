%% Example usage of setdatatips function

clearvars -except MME55 C

%% Select data

Y = xdevs(MME55,'func','B3LYP','D3');

%% Make plot

SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 20 20]);
ax = axes('Parent',fig);

V=violinplot(Y,1:3,'Width',0.4,'MarkerSize',100,'MedianMarkerSize',120,'ViolinColor',C.B,'EdgeColor',[0 0 0],'ShowBox',true,'BoxColor',[0 0 0],'BoxWidth',0.08,'ShowWhiskers',false);

for i = 1:3
    V(1,i).ViolinPlot.LineWidth=2.5;
end

PlotSettings.XTick=2;
PlotSettings.XTickLabel='B3LYP-D3(BJ)';
PlotSettings.XTickLabelRotation=0;
set(ax,PlotSettings)
ylabel(ax,{'Deviation (kcal/mol)'},'FontName','Helvetica Neue','FontSize',30);
ylim([-30,50])

% make legend
[~,icons,~,~]=legend(ax,[V(1,1).ScatterPlot V(1,2).ScatterPlot V(1,3).ScatterPlot],{'def2-SVP','def2-TZVPP','def2-QZVPP'},'Location','northeast','FontSize',15);
scale_lgd_icons(icons,'MarkerEdgeColor','k','LineWidth',2)

clear i N icons

%% set data tips

for i = 1:3
    uistack(V(1,i).ViolinPlot,"bottom") % put violin plot at bottom so scatter plot points can be hovered over/clicked
    V(1,i).ViolinPlot.HitTest=0; % turn off clickability of violinplot outline
    V(1,i).BoxPlot.HitTest=0; % turn off clickability of box
    setdatatips(V(1,i).MedianPlot,[],'Median',V(1,i).MedianPlot.YData) % Median datatip is just median value
    setdatatips(V(1,i).ScatterPlot,"Y",'BH/RE',MME55.reactions.StepName,'Transition Metal',MME55.reactions.Metal,'Multiplicity',MME55.reactions.Multiplicity) % scatter datatip has value, data point, TM, multiplicity
end


%% Save figure

%exportgraphics(fig,'setdatatips_example.pdf','ContentType','vector','BackgroundColor','none');
