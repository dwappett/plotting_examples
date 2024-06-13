%% Violin plots with coloured labels

clearvars -except MME55 C

%% Select data

% Select best variant of each functional (excl. small basis sets) 
% and add latex colour code to name string
X=xnames(MME55,'nosmallbasis','bestvar','log');
ALLviolins.X=string(MME55.funcs.Name(X));
ALLviolins.X=join([MME55.funcs.ColorTex(X) ALLviolins.X]);

% Rank by MADs (overall, not in rungs) and get reordering matrix I,
% apply to names and deviations so these are also ordered by best MAD
T=MME55.stats(X,'MAD');
[~,I]=sortrows(T,"MAD",'descend');
ALLviolins.X=ALLviolins.X(I);
ALLviolins.DAT=xdevs(MME55,'nosmallbasis','bestvar','tbl');
ALLviolins.DAT=ALLviolins.DAT(:,I);

%% Make plot
ALLviolins.figure=figure('Units','centimeters','Position',[1 1 40 45]);
ALLviolins.tl=tiledlayout(ALLviolins.figure,3,1);

%% First set of axes: legend and first 15 methods
ALLviolins.ax1=nexttile(ALLviolins.tl);
hold on;

% custom legend for individual reaction points
for i = 1:10
    scatter(ALLviolins.ax1,1,NaN,'MarkerFaceColor',C.C10(i,:),'MarkerEdgeColor','k');
end
[ALLviolins.lgd,icons,~,~]=legend(unique(MME55.reactions.Reaction,'stable'),'Location','eastoutside','FontSize',12,'FontWeight','bold');
for i = 11:20
    icons(i).Children.MarkerSize = 12;
end
ALLviolins.lgd.Layout.Tile='east';
ALLviolins.lgd.AutoUpdate="off";

% first 15 funcs
ALLviolins.v1=violinplot(ALLviolins.DAT(:,1:15),[],'MarkerSize',60,'MedianMarkerSize',80,'Width',0.4,'ViolinColor',[0.9 0.9 0.9],'ViolinAlpha',0.5,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.1,'GroupOrder',ALLviolins.DAT.Properties.VariableNames(:,1:15));
for i = 1:15
    ALLviolins.v1(1,i).ScatterPlot.MarkerFaceColor = 'flat';
    ALLviolins.v1(1,i).ScatterPlot.CData = C.R_periodic;
    ALLviolins.v1(1,i).ScatterPlot.MarkerEdgeColor = 'k';
    ALLviolins.v1(1,i).ViolinPlot.LineWidth = 1.5; %2
end
clear i icons
hold off;
set(ALLviolins.ax1,'FontName','Helvetica Neue','FontSize',12,'fontweight','bold','LineWidth',2);
set(ALLviolins.ax1,'YGrid','on','YMinorTick','on','GridAlpha',1,'GridColor',[0.9 0.9 0.9], 'GridLineStyle','-');
set(ALLviolins.ax1,'XLim',[0.3,15.7],'XTickLabel',ALLviolins.X(1:15),'XTickLabelRotation',45)
ylim(ALLviolins.ax1,[-30,70]);


%% Second set of axes: next 15 methods
ALLviolins.ax2=nexttile(ALLviolins.tl);
ALLviolins.v2=violinplot(ALLviolins.DAT(:,16:30),[],'MarkerSize',60,'MedianMarkerSize',80,'Width',0.4,'ViolinColor',[0.9 0.9 0.9],'ViolinAlpha',0.5,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.1,'GroupOrder',ALLviolins.DAT.Properties.VariableNames(:,16:30));
for i = 1:15
    ALLviolins.v2(1,i).ScatterPlot.MarkerFaceColor = 'flat';
    ALLviolins.v2(1,i).ScatterPlot.CData = C.R_periodic;
    ALLviolins.v2(1,i).ScatterPlot.MarkerEdgeColor = 'k';
    ALLviolins.v2(1,i).ViolinPlot.LineWidth = 1.5; %2
end
clear i icons
set(ALLviolins.ax2,'FontName','Helvetica Neue','FontSize',12,'fontweight','bold','LineWidth',2);
set(ALLviolins.ax2,'YGrid','on','YMinorTick','on','GridAlpha',1,'GridColor',[0.9 0.9 0.9], 'GridLineStyle','-');
set(ALLviolins.ax2,'XLim',[0.3,15.7],'XTickLabel',ALLviolins.X(16:30),'XTickLabelRotation',45)
ylim(ALLviolins.ax2,[-30,70]);


%% Third set of axes: last 15 methods
ALLviolins.ax3=nexttile(ALLviolins.tl);
ALLviolins.v3=violinplot(ALLviolins.DAT(:,31:45),[],'MarkerSize',60,'MedianMarkerSize',80,'Width',0.4,'ViolinColor',[0.9 0.9 0.9],'ViolinAlpha',0.5,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.1,'GroupOrder',ALLviolins.DAT.Properties.VariableNames(:,31:45));
for i = 1:15
    ALLviolins.v3(1,i).ScatterPlot.MarkerFaceColor = 'flat';
    ALLviolins.v3(1,i).ScatterPlot.CData = C.R_periodic(not(isnan(ALLviolins.DAT{:,1})),:);
    ALLviolins.v3(1,i).ScatterPlot.MarkerEdgeColor = 'k';
    ALLviolins.v3(1,i).ViolinPlot.LineWidth = 1.5; %2
end
clear i icons
set(ALLviolins.ax3,'FontName','Helvetica Neue','FontSize',12,'fontweight','bold','LineWidth',2);
set(ALLviolins.ax3,'YGrid','on','YMinorTick','on','GridAlpha',1,'GridColor',[0.9 0.9 0.9], 'GridLineStyle','-');
set(ALLviolins.ax3,'XLim',[0.3,15.7],'XTickLabel',ALLviolins.X(31:45),'XTickLabelRotation',45)
ylim(ALLviolins.ax3,[-30,70]);

ylabel(ALLviolins.tl,{'Deviation (kcal/mol)'},'FontName','Helvetica Neue','FontSize',25,'fontweight','bold');

%% Save figure
%exportgraphics(ALLviolins.figure,'Outputs/ex9_violin_colouredlabels.pdf','ContentType','vector','BackgroundColor','none');