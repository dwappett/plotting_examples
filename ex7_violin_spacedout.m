%% Violin plot spaced out (MME55 figure 6)

clearvars -except MME55 C

%% Select data

N=numel(MME55.reactions.Step);
Y = [xdevs(MME55,'func','B3LYP','D3') ones([N,1]) xdevs(MME55,'func','M06','D4') ones([N,1]) xdevs(MME55,'func','PWPB95','D3') ones([N,1]) xdevs(MME55,'func','\omegaB2PLYP','D4')];


%% Make plot

SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 45 35]);
ax = axes('Parent',fig);

V=violinplot(Y,{1:15},'Width',0.4,'MarkerSize',100,'MedianMarkerSize',120,'ViolinColor',C.B,'EdgeColor',[0 0 0],'ShowBox',true,'BoxColor',[0 0 0],'BoxWidth',0.08,'ShowWhiskers',false);

for i = 1:15
    V(1,i).ViolinPlot.LineWidth=2.5;
    if i == 4 || i == 8 || i == 12
        V(1,i).EdgeColor='none';
        V(1,i).BoxColor='none';
        V(1,i).ShowMedian=false;
    end
end

PlotSettings.XTick=[2 6 10 14];
PlotSettings.XTickLabel={'B3LYP-D3(BJ)','M06-D4','PWPB95-D3(BJ)','\omegaB2PLYP-D4'};
PlotSettings.XTickLabelRotation=0;
set(ax,PlotSettings)
ylabel(ax,{'Deviation (kcal/mol)'},'FontName','Helvetica Neue','FontSize',30);
ylim([-30,50])

% make legend
[~,icons,~,~]=legend(ax,[V(1,1).ScatterPlot V(1,2).ScatterPlot V(1,3).ScatterPlot],{'def2-SVP','def2-TZVPP','def2-QZVPP'},'Location','north','FontSize',20);
for i=4:6
    icons(i).Children.MarkerSize = 20;
    icons(i).Children.MarkerEdgeColor = 'k';
    icons(i).Children.LineWidth = 2;
end

clear i icons N

%% Add labels
minvals=min(Y);
minvals=transpose(minvals(1,[1:3 5:7 9:11 13:15]));

madvals=[xstats(MME55,'func','B3LYP','D3','MAD','val');xstats(MME55,'func','M06','D4','MAD','val');xstats(MME55,'func','PWPB95','D3','MAD','val');xstats(MME55,'func','\omegaB2PLYP','D4','MAD','val')];
madvals=num2str(madvals,'\x0028%.1f\x0029');

text(ax,[1 5 9 13],minvals([1 4 7 10])-1.5,madvals([1 4 7 10],:),'HorizontalAlignment','center','fontsize',20,'fontweight','bold','Color',C.B(1,:))
text(ax,[2 6 10 14],minvals([2 5 8 11])-1.5,madvals([2 5 8 11],:),'HorizontalAlignment','center','fontsize',20,'fontweight','bold','Color',[0.7020,0.4784,0.2588])
text(ax,[3 7 11 15],minvals([3 6 9 12])-1.5,madvals([3 6 9 12],:),'HorizontalAlignment','center','fontsize',20,'fontweight','bold','Color',C.B(3,:))

%% Save figure

%exportgraphics(fig,'Outputs/ex7_violin_spacedout.pdf','ContentType','vector','BackgroundColor','none');