%% Simple violin plot (MME55 figure 4)

clearvars -except MME55 C

%% Select data: all disp corrected DFAs in each rung as one column

PlotRungs.devs=padcat(xdevs(MME55,'G','alldisp','nosmallbasis','C'), xdevs(MME55,'M','alldisp','nosmallbasis','C'), xdevs(MME55,'H','alldisp','nosmallbasis','C'), xdevs(MME55,'DH','alldisp','nosmallbasis','C'));

%% Make plot
SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 35 30]);
ax = axes('Parent',fig);

V=violinplot(PlotRungs.devs,[],'Width',0.3,'MedianMarkerSize',150,'MarkerSize',15,'ViolinColor',C.C4,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.05);

for i = 1:4
    V(1,i).ViolinPlot.LineWidth=2.5;
end

PlotSettings.XTick=1:4;
PlotSettings.XTickLabel={'GGA' 'meta-GGA/' 'hybrid' 'double'};
PlotSettings.XTickLabelRotation=0;
PlotSettings.XLim=[0.5 4.5];

set(ax,PlotSettings)
ylabel(ax,{'Deviation (kcal/mol)'},'FontSize',30);
ylim(ax,[-30,70])

text(ax,2,-36,{'meta-NGA'},'HorizontalAlignment','center','fontsize',20,'fontweight','bold')
text(ax,4,-36,{'hybrid'},'HorizontalAlignment','center','fontsize',20,'fontweight','bold')

%% MMAD labels
minvals=transpose(min(PlotRungs.devs));
madvals=MME55.rungstats{{'GGA_alldisp','metaGGA_alldisp','hybrid_alldisp','DH_alldisp'},"MAD"};
%madvals=num2str(madvals,'\x0028%.1f\x0029'); % with brackets
madvals=num2str(madvals,'%.1f'); % without brackets
M=["MMAD:";"MMAD:";"MMAD:";"MMAD:"];
madvals=join([M madvals]);

C4mod=[C.C4(1,:);0.7020,0.4784,0.2588;0.2745,0.4745,0.5412;C.C4(4,:)];

for i=1:4
    text(ax,i,minvals(i)-2,madvals(i,:),'HorizontalAlignment','center','fontsize',20,'fontweight','bold','Color',C4mod(i,:)); %,'EdgeColor',C.C4(i,:),'LineWidth',5
end

clear i;

%% Save figure
%exportgraphics(fig,'Outputs/ex6_violin_basic.pdf','ContentType','vector','BackgroundColor','none');