% ---------------------------------------------------------
% MME55 data processing: updated Jan 2024 for group seminar
% ---------------------------------------------------------
% Details of the MME55 benchmark set and tested methods found at
% https://pubs.acs.org/doi/10.1021/acs.jctc.3c00558

clear

%% Add folders to path

addpath("Custom_functions/");
addpath("Outputs/");


%% Read in initial data

% Information about DFAs
MME55.funcs=readtable("MME55_data.xlsx","Sheet","FuncInfo","ReadRowNames",true,'ReadVariableNames',true);
MME55.funcs=convertvars(MME55.funcs,@iscell,'categorical');
MME55.funcs.ColorTex=string(MME55.funcs.ColorTex);
MME55.funcs_bestvariant=readtable("MME55_data.xlsx","Sheet","BestVar",'ReadRowNames',true);

% Information about each point in set
MME55.reactions=readtable("MME55_data.xlsx","Sheet","StepInfo","ReadRowNames",false,'ReadVariableNames',true); % type column 1=RE 2=BH
MME55.reactions.Reaction=categorical(MME55.reactions.Reaction);
MME55.reactions.Step=categorical(MME55.reactions.Step);
MME55.reactions.StepName=categorical(MME55.reactions.StepName);
MME55.reactions.Metal=categorical(MME55.reactions.Metal);
MME55.reactions2=table(categorical({'DMML';'CDO';'Co-NHase';'NiSOD';'Hc';'AAP';'PTE';'AH';'W-FOR';'Mo-Cu CODH';'Zn';'W';'Cu'}),categorical({'Mn';'Fe';'Co';'Ni';'Cu';'Zn';'Zn';'W';'W';'MoCu';'Zn';'W';'Cu'}),[1;2;3;4;5;6;6;7;7;5;6;7;5],'VariableNames',{'Reaction','Metal','TMGroup'},'RowNames',string(1:13));
MME55.TMs=array2table([categorical({'Mn';'Fe';'Co';'Ni';'Cu';'Zn';'MoW';'MoCu';'allCu';'allMoW'}) categorical({'Mn (DMML)';'Fe (CDO)';'Co (CoNHase)';'Ni (NiSOD)';'Cu (Hc)';'Zn (AAP, PTE)';'W (AH, W-FOR)';'MoCu (Mo-Cu CODH)';'All Cu (Hc, Mo-Cu CODH)';'All Mo/W (PcrAB, AH, W-FOR, Mo-Cu CODH)'})],"VariableNames",{'Label','LatexName'});

% Reference Values
MME55.refvals=readtable("MME55_data.xlsx","Sheet","RefVals","ReadRowNames",true,"ReadVariableNames",true);

% DFT energies
MME55.DFAraw=readtable("MME55_data.xlsx","Sheet","DFT-energies","ReadRowNames",true,"ReadVariableNames",true);

%% Calculate deviations, PDs and overall statistics

MME55.devs=array2table(MME55.DFAraw{:,:}-MME55.refvals{:,:},"RowNames",MME55.DFAraw.Properties.RowNames,"VariableNames",MME55.DFAraw.Properties.VariableNames);
MME55.devs.Properties.DimensionNames{2} = 'all';

MME55.percentdevs=100*(MME55.devs.all./abs(MME55.refvals{:,:}));
MME55.percentdevs=array2table(MME55.percentdevs,"VariableNames",MME55.devs.Properties.VariableNames,"RowNames",MME55.devs.Properties.RowNames);

MME55.stats=array2table([MME55.funcs.RungNum stats(MME55.devs) stats(MME55.percentdevs)],"RowNames",MME55.devs.Properties.VariableNames,"VariableNames",{'Rung','MD','MAD','Range','Max','Min','MPD','MAPD','PD_Range','PD_Max','PD_Min'});

%% Calculate statistics for overall rungs (QZ/3c only)

rung={'G'; 'M'; 'H'; 'DH'};
dtype={'U'; 'D3'; 'D4'; 'V'; 'alldisp'};
lab={'GGA_plain';'metaGGA_plain';'hybrid_plain';'DH_plain';'GGA_D3';'metaGGA_D3';'hybrid_D3';'DH_D3';'GGA_D4';'metaGGA_D4';'hybrid_D4';'DH_D4';'GGA_V';'metaGGA_V';'hybrid_V';'DH_V';'GGA_alldisp';'metaGGA_alldisp';'hybrid_alldisp';'DH_alldisp'};

for i=1:5 % each dispersion category
    for j=1:4 % each rung
        MME55.rungstats(4*(i-1)+j,:)=[stats(xdevs(MME55,rung{j},dtype{i},'nosmallbasis','C')) stats(xdevs(MME55,rung{j},dtype{i},'nosmallbasis','percent','C'))];
    end
end
MME55.rungstats=array2table(MME55.rungstats,"RowNames",lab,"VariableNames",{'MD','MAD','Range','Max','Min','MPD','MAPD','PD_Range','PD_Max','PD_Min'});

clear rung dtype lab i j


%% Calculate individual reaction/subset statistics

% Stats for each reaction 1:10 in periodic order
for i=1:10
    MME55.enzymesubsets(i).stats=array2table([MME55.funcs.RungNum stats(MME55.devs{MME55.reactions.RNumPeriodic==i,:}) stats(MME55.percentdevs{MME55.reactions.RNumPeriodic==i,:})],"RowNames",MME55.devs.Properties.VariableNames,"VariableNames",{'RungNum','MD','MAD','Range','Max','Min','MPD','MAPD','PD_Range','PD_Max','PD_Min'});
end

% Both Zn enzymes together
MME55.enzymesubsets(11).stats=array2table([MME55.funcs.RungNum stats(MME55.devs{MME55.reactions.TMGroup==6,:}) stats(MME55.percentdevs{MME55.reactions.TMGroup==6,:})],"RowNames",MME55.devs.Properties.VariableNames,"VariableNames",{'RungNum','MD','MAD','Range','Max','Min','MPD','MAPD','PD_Range','PD_Max','PD_Min'});
% Both W enzymes together
MME55.enzymesubsets(12).stats=array2table([MME55.funcs.RungNum stats(MME55.devs{MME55.reactions.TMGroup==7,:}) stats(MME55.percentdevs{MME55.reactions.TMGroup==7,:})],"RowNames",MME55.devs.Properties.VariableNames,"VariableNames",{'RungNum','MD','MAD','Range','Max','Min','MPD','MAPD','PD_Range','PD_Max','PD_Min'});
% Both Cu enzymes together
MME55.enzymesubsets(13).stats=array2table([MME55.funcs.RungNum stats(MME55.devs{MME55.reactions.TMGroup==5,:}) stats(MME55.percentdevs{MME55.reactions.TMGroup==5,:})],"RowNames",MME55.devs.Properties.VariableNames,"VariableNames",{'RungNum','MD','MAD','Range','Max','Min','MPD','MAPD','PD_Range','PD_Max','PD_Min'});

clear i

%% Identify best variants of each DFA

bas={'DZ';'TZ';'QZ'};
UF=unique(MME55.funcs.Functional,'stable');

% By overall MAD and MAPD
for i = 1:numel(UF)
    F=UF(i,1);
    if F == 'B3LYP' | F == 'M06' | F == 'PWPB95' | F == '\omegaB2PLYP'
        for b = 1:3
            FMAD=xstats(MME55,'MAD','func',F,bas(b),'alldisp');
            [M,I]=min(FMAD.Variables);
            MME55.funcs_bestvariant(FMAD.Properties.RowNames(I),'DispOnly_MAD')={1};
            if xstats(MME55,'MAD','func',F,bas(b),'U','val') < M
                MME55.funcs_bestvariant(xnames(MME55,'func',F,bas(b),'U','log'),'Overall_MAD')={1};
            else; MME55.funcs_bestvariant(FMAD.Properties.RowNames(I),'Overall_MAD')={1};
            end
            FMAPD=xstats(MME55,'MAPD','func',F,bas(b),'alldisp');
            [N,J]=min(FMAPD.Variables);
            MME55.funcs_bestvariant(FMAPD.Properties.RowNames(J),'DispOnly_MAPD')={1};
            if xstats(MME55,'MAPD','func',F,bas(b),'U','val') < N
                MME55.funcs_bestvariant(xnames(MME55,'func',F,bas(b),'U','log'),'Overall_MAPD')={1};
            else; MME55.funcs_bestvariant(FMAPD.Properties.RowNames(J),'Overall_MAPD')={1};
            end
        end
    elseif F == '\omegaB88PP86' | F == '\omegaPBEPP86' 
        MME55.funcs_bestvariant(xnames(MME55,'func',F,'log'),'Overall_MAD')={1};
        MME55.funcs_bestvariant(xnames(MME55,'func',F,'log'),'Overall_MAPD')={1};
    else
        FMAD=xstats(MME55,'MAD','func',F,'alldisp');
        [M,I]=min(FMAD.Variables);
        MME55.funcs_bestvariant(FMAD.Properties.RowNames(I),'DispOnly_MAD')={1};
        if xstats(MME55,'MAD','func',F,'U','val') < M
            MME55.funcs_bestvariant(xnames(MME55,'func',F,'U','log'),'Overall_MAD')={1};
        else; MME55.funcs_bestvariant(FMAD.Properties.RowNames(I),'Overall_MAD')={1};
        end
        FMAPD=xstats(MME55,'MAPD','func',F,'alldisp');
        [N,J]=min(FMAPD.Variables);
        MME55.funcs_bestvariant(FMAPD.Properties.RowNames(J),'DispOnly_MAPD')={1};
        if xstats(MME55,'MAPD','func',F,'U','val') < N
            MME55.funcs_bestvariant(xnames(MME55,'func',F,'U','log'),'Overall_MAPD')={1};
        else; MME55.funcs_bestvariant(FMAPD.Properties.RowNames(J),'Overall_MAPD')={1};
        end
    end
end

% By MAD and MAPD of each individual reaction/subset
for i = 1:numel(UF)
    F=UF(i,1);
    for j = 1:13
        if F == 'B3LYP' | F == 'M06' | F == 'PWPB95' | F == '\omegaB2PLYP'
            FMAD=xstats(MME55,'sys',j,'MAD','func',F,'DZ');
            [~,I]=min(FMAD.Variables);
            X=strcmpi(MME55.stats.Properties.RowNames,FMAD.Properties.RowNames(I));
            MME55.funcs_bestvariant(X,2+j)={1};
            FMAPD=xstats(MME55,'sys',j,'MAPD','func',F,'DZ');
            [~,J]=min(FMAPD.Variables);
            Y=strcmpi(MME55.stats.Properties.RowNames,FMAPD.Properties.RowNames(J));
            MME55.funcs_bestvariant(Y,17+j)={1};
            FMAD=xstats(MME55,'sys',j,'MAD','func',F,'TZ');
            [~,I]=min(FMAD.Variables);
            X=strcmpi(MME55.stats.Properties.RowNames,FMAD.Properties.RowNames(I));
            MME55.funcs_bestvariant(X,2+j)={1};
            FMAPD=xstats(MME55,'sys',j,'MAPD','func',F,'TZ');
            [~,J]=min(FMAPD.Variables);
            Y=strcmpi(MME55.stats.Properties.RowNames,FMAPD.Properties.RowNames(J));
            MME55.funcs_bestvariant(Y,17+j)={1};
            FMAD=xstats(MME55,'sys',j,'MAD','func',F,'QZ');
            [~,I]=min(FMAD.Variables);
            X=strcmpi(MME55.stats.Properties.RowNames,FMAD.Properties.RowNames(I));
            MME55.funcs_bestvariant(X,2+j)={1};
            FMAPD=xstats(MME55,'sys',j,'MAPD','func',F,'QZ');
            [~,J]=min(FMAPD.Variables);
            Y=strcmpi(MME55.stats.Properties.RowNames,FMAPD.Properties.RowNames(J));
            MME55.funcs_bestvariant(Y,17+j)={1};
        else
            FMAD=xstats(MME55,'sys',j,'MAD','func',F);
            [~,I]=min(FMAD.Variables);
            X=strcmpi(MME55.stats.Properties.RowNames,FMAD.Properties.RowNames(I));
            MME55.funcs_bestvariant(X,2+j)={1};
            FMAPD=xstats(MME55,'sys',j,'MAPD','func',F);
            [~,J]=min(FMAPD.Variables);
            Y=strcmpi(MME55.stats.Properties.RowNames,FMAPD.Properties.RowNames(J));
            MME55.funcs_bestvariant(Y,17+j)={1};
        end
    end
end

MME55.funcs_bestvariant=convertvars(MME55.funcs_bestvariant,@isnumeric,'logical');

clear bas UF i F b FMAD FMAPD M I N J j X Y

%% Create tables of MD/MAD/MAPD for bars2 and latex examples

UF=unique(MME55.funcs.Functional,'stable');

for i = 1:numel(UF)
    F=UF(i,1);
    rung=MME55.funcs(MME55.funcs.Functional==F,"RungNum");
    MME55.BarPlots.MDgrouped(i,:)=[rung{1,:} xstats(MME55,'func',F,'nosmallbasis','U','MD','val') xstats(MME55,'func',F,'nosmallbasis','D3','MD','val') xstats(MME55,'func',F,'nosmallbasis','D4','MD','val') xstats(MME55,'func',F,'nosmallbasis','V','MD','val')];
    MME55.BarPlots.MADgrouped(i,:)=[rung{1,:} xstats(MME55,'func',F,'nosmallbasis','U','MAD','val') xstats(MME55,'func',F,'nosmallbasis','D3','MAD','val') xstats(MME55,'func',F,'nosmallbasis','D4','MAD','val') xstats(MME55,'func',F,'nosmallbasis','V','MAD','val')];
    MME55.BarPlots.MAPDgrouped(i,:)=[rung{1,:} xstats(MME55,'func',F,'nosmallbasis','U','MAPD','val') xstats(MME55,'func',F,'nosmallbasis','D3','MAPD','val') xstats(MME55,'func',F,'nosmallbasis','D4','MAPD','val') xstats(MME55,'func',F,'nosmallbasis','V','MAPD','val')];
end
MME55.BarPlots.MDgrouped=array2table(MME55.BarPlots.MDgrouped,"RowNames",string(UF),"VariableNames",{'RungNum','Plain','D3','D4','V'});
MME55.BarPlots.MADgrouped=array2table(MME55.BarPlots.MADgrouped,"RowNames",string(UF),"VariableNames",{'RungNum','Plain','D3','D4','V'});
MME55.BarPlots.MAPDgrouped=array2table(MME55.BarPlots.MAPDgrouped,"RowNames",string(UF),"VariableNames",{'RungNum','Plain','D3','D4','V'});

clear UF i F rung


%% Define colour matrices for plots

% Basic 10 colour and 4 colour palette
    C.C10=linspecer(10);
    C.C4=linspecer(4,'colorblind');

% Matrix defining each point's colour by reaction (using 10 colour palette)
    for i=1:height(MME55.reactions)
        C.R_periodic(i,:)=C.C10(MME55.reactions.RNumPeriodic(i),:);
    end

% Matrix defining each functional's colour by rung (using 4 colour palette)
    C.FR=zeros([numel(MME55.funcs.Name),3]);
    for i = 1:numel(MME55.funcs.Name)-2
        r=MME55.funcs{i,"RungNum"};
        C.FR(i,:)=C.C4(r,:);
    end

% Colours for basis set comparisons (based on C4)
    C.B=[C.C4(1,:);C.C4(2,:);C.C4(4,:);1 1 1;C.C4(1,:);C.C4(2,:);C.C4(4,:);1 1 1;C.C4(1,:);C.C4(2,:);C.C4(4,:);1 1 1;C.C4(1,:);C.C4(2,:);C.C4(4,:)];

clear i r

%% LOCAL FUNCTION TO CALCULATE STATISTICS
% takes array A and calculates MD, MAD, range, max, min in that order

function S = stats(A)
    if istable(A)
        A = A{:,:};
    end
    if isempty(A)
        S = NaN([1,5]);
    else
        S = transpose([mean(A,'omitnan'); mean(abs(A),'omitnan'); range(A); max(A); min(A)]);
    end
end