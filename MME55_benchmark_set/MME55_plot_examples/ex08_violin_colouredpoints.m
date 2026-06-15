%% Violin plots with individually coloured points (MME55 fig 5)

clearvars -except MME55 C

%% Select data

Hfuncs={'B3LYP_D3BJ','B3LYPst_D3BJ','BHLYP_D4','CAM_B3LYP_D4','M06_D4','M062X_D4','MPW1B95_D3BJ','PW6B95_D3BJ','wB97M_V','wB97X_V'}; %'TPSSh_D3BJ'
DHfuncs={'B2PLYP_D3BJ','B2GP_PLYP_D3BJ','B2K_PLYP_D3BJ','PBE0_DH_D4','PWPB95_D3BJ','revDOD_PBEP86_D4','revDSD_PBEP86_D4','SOS0_PBE0_2_D3BJ','wB2PLYP_D4','wB2GPPLYP_D4'}; %'mPW2PLYP_D3BJ'

% Put funcs in MAD order
TH=MME55.stats(Hfuncs,'MAD');
[TH,I]=sortrows(TH,'MAD','descend');
Hfuncs=Hfuncs(I);
TD=MME55.stats(DHfuncs,'MAD');
[TD,I]=sortrows(TD,'MAD','descend');
DHfuncs=DHfuncs(I);

% Get deviations
Hdevs=MME55.devs(:,Hfuncs);
DHdevs=MME55.devs(:,DHfuncs);


%% Make plot

SetPlotDefaults


fig=figure('Units','centimeters','Position',[1 1 65 30]);
tl=tiledlayout(fig,1,2,"TileSpacing","tight");

% axes for hybrid DFAs in first tile
ax_Hdevs=nexttile(tl);
hold on;

% empty plot for legend
for i = 1:10
    scatter(ax_Hdevs,1,NaN,'MarkerFaceColor',C.C10(i,:),'MarkerEdgeColor','k');
end
[lgd,icons,~,~]=legend(unique(MME55.reactions.Reaction,'stable'),'Location','eastoutside','FontSize',15);
for i = 11:20
    icons(i).Children.MarkerSize = 15;
end
lgd.Layout.Tile='east';
lgd.AutoUpdate="off";

% plot violins of hybrid DFA deviations
vH_devs=violinplot(Hdevs,[],'MarkerSize',80,'MedianMarkerSize',100,'Width',0.4,'ViolinColor',[0.9 0.9 0.9],'ViolinAlpha',0.5,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.1,'GroupOrder',Hfuncs);
for i = 1:10
    vH_devs(1,i).ScatterPlot.MarkerFaceColor = 'flat';
    vH_devs(1,i).ScatterPlot.CData = C.R_periodic;
    vH_devs(1,i).ScatterPlot.MarkerEdgeColor = 'k';
    vH_devs(1,i).ViolinPlot.LineWidth = 1.5; %2
end
clear i icons
hold off;

set(ax_Hdevs,PlotSettings)
ax_Hdevs.XTickLabel=MME55.funcs{Hfuncs,"Name"};
ax_Hdevs.XLim=[0.3,10.7];
ax_Hdevs.YLim=[-30,40];
%ylim(ax_Hdevs,[-30,40]);


% axes for double hybrids in second tile
ax_DHdevs=nexttile(tl);

% violins of DH deviations
vDH_devs=violinplot(DHdevs,[],'MarkerSize',80,'MedianMarkerSize',100,'Width',0.4,'ViolinColor',[0.9 0.9 0.9],'ViolinAlpha',0.5,'EdgeColor',[0 0 0],'BoxColor',[0 0 0],'BoxWidth',0.1,'GroupOrder',DHfuncs);
for i = 1:10
    vDH_devs(1,i).ScatterPlot.MarkerFaceColor = 'flat';
    vDH_devs(1,i).ScatterPlot.CData = C.R_periodic(not(isnan(Hdevs{:,1})),:);
    vDH_devs(1,i).ScatterPlot.MarkerEdgeColor = 'k';
    vDH_devs(1,i).ViolinPlot.LineWidth = 1.5; %2
end
clear i

set(ax_DHdevs,PlotSettings)
ax_DHdevs.XTickLabel=MME55.funcs{DHfuncs,"Name"};
ax_DHdevs.XLim=[0.3,10.7];
ax_DHdevs.YLim=[-30,40];

ylabel(tl,{'Deviation (kcal/mol)'},'FontSize',30,'fontweight','bold');

%% Identify max and min steps, label points

[lab.Hmaxdevval,lab.Hmaxdevstep]=max(Hdevs{:,:});
lab.Hmaxdevstep=MME55.reactions.StepName(lab.Hmaxdevstep);
[lab.Hmindevval,lab.Hmindevstep]=min(Hdevs{:,:});
lab.Hmindevstep=MME55.reactions.StepName(lab.Hmindevstep);

[lab.DHmaxdevval,lab.DHmaxdevstep]=max(DHdevs{:,:});
lab.DHmaxdevstep=MME55.reactions.StepName(lab.DHmaxdevstep);
[lab.DHmindevval,lab.DHmindevstep]=min(DHdevs{:,:});
lab.DHmindevstep=MME55.reactions.StepName(lab.DHmindevstep);

text(ax_Hdevs,1.1,lab.Hmaxdevval(1)-1,lab.Hmaxdevstep(1),'HorizontalAlignment','left','fontsize',10,'fontweight','bold') 
text(ax_Hdevs,2:10,lab.Hmaxdevval(2:10)+2,lab.Hmaxdevstep(2:10),'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
text(ax_DHdevs,1:10,lab.DHmaxdevval+2,lab.DHmaxdevstep,'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 

for i=1:10
    if lab.Hmindevstep(i)=="Mo-Cu CODH RE1"
        text(ax_Hdevs,i,lab.Hmindevval(i)-2,"Mo-Cu CODH",'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
        text(ax_Hdevs,i,lab.Hmindevval(i)-3.7,"RE1",'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
    elseif lab.Hmindevstep(i)=="Mo-Cu CODH RE2"
        text(ax_Hdevs,i,lab.Hmindevval(i)-2,"Mo-Cu CODH",'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
        text(ax_Hdevs,i,lab.Hmindevval(i)-3.7,"RE2",'HorizontalAlignment','center','fontsize',10,'fontweight','bold')
    else
        text(ax_Hdevs,i,lab.Hmindevval(i)-2,lab.Hmindevstep(i),'HorizontalAlignment','center','fontsize',10,'fontweight','bold')
    end

    if lab.DHmindevstep(i)=="Mo-Cu CODH RE1"
        text(ax_DHdevs,i,lab.DHmindevval(i)-2,"Mo-Cu CODH",'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
        text(ax_DHdevs,i,lab.DHmindevval(i)-3.7,"RE1",'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
    else
        text(ax_DHdevs,i,lab.DHmindevval(i)-2,lab.DHmindevstep(i),'HorizontalAlignment','center','fontsize',10,'fontweight','bold') 
    end
end

% MADs at bottom of plot
text(ax_Hdevs,1:10,-27*ones([10 1]),num2str(TH.Variables,'\x0028%.1f\x0029'),'HorizontalAlignment','center','fontsize',15,'fontweight','bold') 
text(ax_DHdevs,1:10,-27*ones([10 1]),num2str(TD.Variables,'\x0028%.1f\x0029'),'HorizontalAlignment','center','fontsize',15,'fontweight','bold')


%% Save figure
%exportgraphics(fig,'Outputs/ex8_violin_colouredpoints.pdf','ContentType','vector','BackgroundColor','none');
