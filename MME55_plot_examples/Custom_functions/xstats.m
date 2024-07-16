function A = xstats(MME55,varargin)
%--------------------------------------------------------------------------
% EXTRACT SPECIFIC STATISTICAL VALUES FROM MME55 DATA STRUCTURE
% Created by D. Wappett (2023)
%--------------------------------------------------------------------------
% Required inputs:
%   MME55: data structure where:
%   MME55.stats = table of stats
%   MME55.reactions = row categories
%   MME55.funcs = column categories
% Options for stats:
%   default is all
%   or one of: 'MD' 'MAD' 'Range' 'Max' 'Min' 'MPD' 'MAPD' 'PD_Range' 'PD_Max' 'PD_Min'
% Options for functionals:
%   Specify functional: 'func' then name of func
%   Rung of Jacob's ladder: 'G' 'M' 'H' 'DH'
%   Dispersion correction: 'U' 'D3' 'D4' 'V' 
%       'alldisp'(=D3+D4+V) 'BestDisp' 'BestVar'
%   Basis set: 'DZ' 'TZ' 'QZ' '3c' 'nosmallbasis'=QZ+3c
% Options for energies:
%   Default is only overall
%   Enzyme/metal: 'Sys' plus 1:13 or name (DMML, CDO, Co-NHase, NiSOD, Hc, AAP, PTE, AH, W-FOR, Mo-Cu CODH, Zn, W, Cu)
% Output format:
%   default: table
%   'val' for just value
%   'sort': if all stats, sorts by MAD
%--------------------------------------------------------------------------


% set up defaults
DFA = [ones(numel(MME55.funcs.Functional),1)];
Rung = [ones(numel(MME55.funcs.Rung),1)];
Disp = [ones(numel(MME55.funcs.Dispersion),1)];
BestDisp = 0;
Basis = [ones(numel(MME55.funcs.BasisSet),1)];
OutType = 2:11;
Num = 0;
System = 0;
St = 0;

% read inputs
if nargin>1
    for k=1:length(varargin)
        if strcmpi(varargin{k},'G')
            Rung = MME55.funcs.Rung == 'GGA';
            continue;
        elseif strcmpi(varargin{k},'M')
            Rung = MME55.funcs.Rung == 'meta-GGA';
            continue;
        elseif strcmpi(varargin{k},'H')
            Rung = MME55.funcs.Rung == 'hybrid';
            continue;
        elseif strcmpi(varargin{k},'DH')
            Rung = MME55.funcs.Rung == 'double hybrid';
            continue;
        end

        if strcmpi(varargin{k},'U')
            Disp = MME55.funcs.Dispersion == 'none';
            continue;
        elseif strcmpi(varargin{k},'D3')
            Disp = MME55.funcs.Dispersion == 'D3';
            continue;
        elseif strcmpi(varargin{k},'D4')
            Disp = MME55.funcs.Dispersion == 'D4';
            continue;
        elseif strcmpi(varargin{k},'V')
            Disp = MME55.funcs.Dispersion == 'VV10';
            continue;
        elseif strcmpi(varargin{k},'alldisp')
            Disp = not(MME55.funcs.Dispersion == 'none');
            continue;
        elseif strcmpi(varargin{k},'BestDisp')
            BestDisp = MME55.funcs_bestvariant(:,{'DispOnly_MAD','DispOnly_MAPD'});
            continue;
        elseif strcmpi(varargin{k},'BestVar')
            BestDisp = MME55.funcs_bestvariant(:,{'Overall_MAD','Overall_MAPD'});
            continue;
        end

        if strcmpi(varargin{k},'DZ')
            Basis = MME55.funcs.BasisSet == 'def2-SVP';
            continue;
        elseif strcmpi(varargin{k},'TZ')
            Basis = MME55.funcs.BasisSet == 'def2-TZVPP';
            continue;
        elseif strcmpi(varargin{k},'QZ')
            Basis = MME55.funcs.BasisSet == 'def2-QZVPP';
            continue;
        elseif strcmpi(varargin{k},'3c')
            Basis = MME55.funcs.BasisSet == '3c';
            continue;
        elseif strcmpi(varargin{k},'nosmallbasis')
            Basis = MME55.funcs.BasisSet == 'def2-QZVPP' | MME55.funcs.BasisSet == '3c';
            continue;
        end

        if strcmpi(varargin{k},'func')
            DFA = MME55.funcs.Functional == varargin{k+1};
            continue;
        end

        if strcmpi(varargin{k},'Sys')
            if isnumeric(varargin{k+1}) == 0 
                System=find(MME55.reactions2.Reaction == varargin{k+1});
            else
                System=varargin{k+1};
            end
            continue;
        end

        if strcmpi(varargin{k},'val')
            Num = 1;
            continue;
        end

        if strcmpi(varargin{k},'sort')
            St = 1;
            continue;
        end

        if strcmpi(varargin{k},'MD')
            OutType = 2;
            continue;
        elseif strcmpi(varargin{k},'MAD')
            OutType = 3;
            continue;
        elseif strcmpi(varargin{k},'Range')
            OutType = 4;
            continue;
        elseif strcmpi(varargin{k},'Max')
            OutType = 5;
            continue;
        elseif strcmpi(varargin{k},'Min')
            OutType = 6;
            continue;
        elseif strcmpi(varargin{k},'MPD')
            OutType = 7;
            continue;    
        elseif strcmpi(varargin{k},'MAPD')
            OutType = 8;
            continue;
        elseif strcmpi(varargin{k},'PD_Range')
            OutType = 9;
            continue;
        elseif strcmpi(varargin{k},'PD_Max')
            OutType = 10;
            continue;
        elseif strcmpi(varargin{k},'PD_Min')
            OutType = 11;
            continue;
        end
    end
end

% Decide how to select best dispersion corrected variant (1=MAD or 2=MAPD)
if (ge(OutType,7) & le(OutType,11)) && (istable(BestDisp) == 1)
    Disp=BestDisp{:,2};
elseif istable(BestDisp) == 1
    Disp=BestDisp{:,1};
end

% Define which funcs to include
OutFunc = DFA & Rung & Disp & Basis;

% Decide if using overall stats or system stats
if System == 0
    A = MME55.stats(OutFunc,OutType);
else
    A = MME55.enzymesubsets(System).stats(OutFunc,OutType);
end

% Decide if stats are being sorted
if St == 1 && numel(OutType) == 1
    A = sortrows(A,1,"descend","ComparisonMethod","abs");
elseif St == 1 && numel(OutType) > 1
    A = sortrows(A,"MAD","descend");
end

% Give array if requested
if Num == 1
    A = A.Variables;
end

% If no stats exist for selected combo, print NaN
if isempty(A)
    A = NaN;
end
