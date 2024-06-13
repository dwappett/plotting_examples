%% Overlaid bar chart
% Simple bar chart with overlaid bars
% Good for plain vs corrected DFAs, MAD and MDs together, etc

clearvars -except MME55 C

%% Select data for plot:

% Table of MDs and MADs, best variant chosen based on MAD, QZ results only
Y = MME55.stats(MME55.funcs_bestvariant.DispOnly_MAD & MME55.funcs.BasisSet=='def2-QZVPP', 1:3);

% sort by MADs descending
Y = sortrows(Y,[1 3],{'ascend','descend'});

% Define X values from table row names
X = categorical(MME55.funcs{Y.Properties.RowNames,'Name'},MME55.funcs{Y.Properties.RowNames,'Name'});
%X = categorical(MME55.funcs{Y.Properties.RowNames,'Name'});

% Define colour matrix to colour bars by rung
for i=1:height(Y)-1
    Col(i,:)=C.C4(Y.Rung(i),:);
end
Col(height(Y),:)=[0 0 0];


%% Make plot
SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 60 30]);
ax = axes(fig);

hold on

% Option 1: all bars black and white
%B2=bar(X,Y{:,"MAD"},0.8,'FaceColor','w','EdgeColor','k','LineWidth',3);
%b2=bar(X,Y{:,"MD"},0.5,'FaceColor','k','EdgeColor','none');

% Option 2: coloured by rung (plus empty placeholder bars to make legend icons black)
B=bar(X,Y{:,"MAD"},0.8,'FaceColor','flat','FaceAlpha',0.1,'EdgeColor','flat','LineWidth',3,'CData',Col);
b=bar(X,Y{:,"MD"},0.5,'FaceColor','flat','EdgeColor','none','CData',Col);
B2=bar(NaN,NaN,0.8,'FaceColor','k','FaceAlpha',0.1,'EdgeColor','k','LineWidth',3);
b2=bar(NaN,NaN,0.5,'FaceColor','k','EdgeColor','none');

hold off

set(ax,PlotSettings)
ylabel(ax,{'Mean (absolute) deviation (kcal/mol)'},'FontSize',25);
ylim(ax,[-2,8])
title(ax,"Results for the best (lowest MAD) dispersion corrected variant of each method",'FontSize',25)

lgd=legend(ax,[B2 b2],{'MAD','MD'},'Location','northeast','Orientation','vertical');

%% Add labels for rungs

text(ax,4,7.3,"GGA","Color",C.C4(1,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")
text(ax,10.5,6.3,"meta-GGA","Color",C.C4(2,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")
text(ax,20.5,4.3,"hybrid","Color",C.C4(3,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")
text(ax,33.5,3.3,"double hybrid","Color",C.C4(4,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")


%% Save figure

%exportgraphics(fig,'Outputs/ex2_bars_overlaid.pdf','ContentType','vector','BackgroundColor','none');