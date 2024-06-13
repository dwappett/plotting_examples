%% Boxplot with different coloured subsets (eg rungs)

clearvars -except MME55 C

%% Set up data:
rungs={'G','M','H','DH'};
% get best variant of each func in rungs, then use sorted names to get devs
for i=1:4
    MADsorted{i}=xstats(MME55,'MAD',rungs{i},'nosmallbasis','bestdisp','sort');
    Ydevs{i}=MME55.devs{:,MADsorted{i}.Properties.RowNames};
    X{i}=MME55.funcs.Name(MADsorted{i}.Properties.RowNames);
end
% pad devs tables with NaNs to make correct size
Ydevs = plotpadding(Ydevs);

%% Make plot
SetPlotDefaults

fig = figure('Units','centimeters','Position',[1 1 60 30]);
ax = axes(fig);

hold on
for i=1:4
    B{i}=boxplot_custom(Ydevs{i},'fillcolor',C.C4(i,:),'outlier_multiplier',inf);
end
hold off

PlotSettings.XTickLabel = [X{1};X{2};X{3};X{4}];

set(ax,PlotSettings)

ylabel(ax,{'Deviation (kcal/mol)'},'FontSize',25);
ylim(ax,[-40 70])

%% Add labels for rungs

text(ax,4.5,-30,"GGA","Color",C.C4(1,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")
text(ax,12,-30,"meta-GGA","Color",C.C4(2,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")
text(ax,22.5,-30,"hybrid","Color",C.C4(3,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")
text(ax,36.5,-30,"double hybrid","Color",C.C4(4,:),"HorizontalAlignment","center","FontSize",25,"FontWeight","bold")

%% Save figure

%exportgraphics(fig,'Outputs/ex5_boxplot_subsetscoloured.pdf','ContentType','vector','BackgroundColor','none');

%% LOCAL FUNCTION FOR PADDING OUT DATA
% take cell array of data tables/arrays and pad with NaNs so all the same
% width without overlapping columns

function P = plotpadding(Y)
    for i=1:numel(Y)
        % turn table into array for simplicity
        if istable(Y{i})
            Y{i}=Y{i}{:,:};
        end
        % write first section of each array
        if i==1
            P{i}=Y{1};
        else
            P{i}=NaN(size(Y{1}));
        end
        % write subsequent sections of each array
        for j=2:numel(Y)
            if j==i
                P{i}=[P{i} Y{j}];
            else
                P{i}=[P{i} NaN(size(Y{j}))];
            end
        end
    end
end
