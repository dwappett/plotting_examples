%% Tiled layouts with overlaid axes
% Similar approach to the scatter plots in fig 2 of my CPS-extrapolated reference values paper
% (https://pubs.acs.org/doi/10.1021/acs.jpca.3c05086)

clearvars -except MME55 C

%% Select data
% Calculate rung MMAPDs for each enzyme separately
% (Will plot overall values straight from MME55.rungstats table)
rung={'G'; 'M'; 'H'; 'DH'};

for i=1:10
    for j=1:4
        Y(i,j)=mean(abs(xdevs(MME55,'sys',i,rung{j},'alldisp','nosmallbasis','percent','C')));
    end
end
Y=array2table(Y,"RowNames",string(MME55.reactions2.Reaction(1:10)),"VariableNames",{'GGA','meta-GGA','hybrid','double hybrid'});

clear i j rung


%% Make plot

fig=figure('Units','centimeters','Position',[1 1 50 30]);
tl=tiledlayout(fig,2,2);

ylims=[0 160; 0 160; 0 160; 0 160];
runglab={'GGA','meta-GGA','hybrid','double hybrid'};

for i=1:4
    ax{i}=nexttile(tl);
        b_all{i}=bar(1,MME55.rungstats{16+i,"MAPD"},0.8,"FaceColor","k","EdgeColor","none");
        set(ax{i},"Box","off","YGrid","on",'fontsize',20,'fontweight','bold')
        set(ax{i},'XLim',[-0.5 13.5],'XTick',1,'XTickLabel',"MME55",'XTickLabelRotation',0)
        set(ax{i},'YLim',ylims(i,:),'YTick',ylims(i,1):40:ylims(i,2))
        title(ax{i},runglab{i},'fontsize',20,'fontweight','bold')
    
    ax2{i}=axes(tl);
    ax2{i}.Layout.Tile = i;
        b_sys{i}=bar(3:12,Y{:,i},0.8,"FaceColor","flat","EdgeColor","none","CData",C.C10);
        set(ax2{i},"Box","off","YGrid","off",'fontsize',15,'color','none')
        set(ax2{i},'XLim',[-0.5 13.5],'XTick',3:12,'XTickLabel',Y.Properties.RowNames,'XTickLabelRotation',45)
        set(ax2{i},'YLim',ylims(i,:))
        ax2{i}.YAxis.Visible = 'off';
end

tl.YLabel.String={'MMAPD (%)'};
tl.YLabel.FontWeight='bold';
tl.YLabel.FontSize=30;
title(tl,'Rung MMAPDs for the overall MME55 set and each individual reaction','fontweight','bold','fontsize',30)


%% Save figure
%exportgraphics(fig,'Outputs/ex11_tiledlayout_overlaidaxes.pdf','ContentType','vector','BackgroundColor','none');