%% Examples of latex tables generated with my function textab

clearvars -except MME55 C

%% write table of MADs (eg MME55 table 5)

T=MME55.BarPlots.MADgrouped(:,2:end);
rungs=unique(MME55.funcs.Rung,'stable');
for i=1:height(T)
    rungname(i,1)=rungs(MME55.BarPlots.MADgrouped{i,"RungNum"},1);
end
T=addvars(T,rungname,'NewVariableNames','Type','Before','Plain');
clear i rungs rungname

%textab(T,1,'Outputs/ex12_latextable.tex')
textab(T,1)