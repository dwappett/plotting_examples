function A = xdevs(MME55,varargin)
%--------------------------------------------------------------------------
% EXTRACT SPECIFIC DEVIATIONS FROM MME55 DATA STRUCTURE
% Created by D. Wappett (2023)
%--------------------------------------------------------------------------
% Required inputs:
%   MME55: data structure where:
%   MME55.devs = deviations table
%   MME55.reactions = row categories
%   MME55.funcs = column categories
% Options for functionals:
%   Specify functional: 'func' then name of func
%   Rung of Jacob's ladder: 'G' 'M' 'H' 'DH'
%   Dispersion correction: 'U' 'D3' 'D4' 'V' 
%       'alldisp'(=D3+D4+V) 'BestDisp' 'BestVar' (best by MAD)
%   Basis set: 'DZ' 'TZ' 'QZ' '3c' 'nosmallbasis'=QZ+3c
% Options for energies:
%   Enzyme/metal: 'Sys' plus 1:13 or name (DMML, CDO, Co-NHase, NiSOD, Hc, AAP, PTE, AH, W-FOR, Mo-Cu CODH, Zn, W, Cu)
%   Shell open/closed: 'OS' 'CS'
% Output format options:
%   Concatenate into one single column: 'C'
%   Table output: 'tbl' (good for checking output is correct)
%   Percentage deviations: 'percent' or 'PD'
%--------------------------------------------------------------------------

% set up defaults
DFA = [ones(numel(MME55.funcs.Functional),1)];
Rung = [ones(numel(MME55.funcs.Rung),1)];
Disp = [ones(numel(MME55.funcs.Dispersion),1)];
Basis = [ones(numel(MME55.funcs.BasisSet),1)];
System = transpose(1:numel(MME55.reactions.Reaction));
Shell = transpose(1:numel(MME55.reactions.Multiplicity));
EType = transpose(1:numel(MME55.reactions.EType));
C = 0;
tbl = 0;
PDs = 0;
BestDisp = 0;

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
            continue
        elseif strcmpi(varargin{k},'D4')
            Disp = MME55.funcs.Dispersion == 'D4';
            continue;
        elseif strcmpi(varargin{k},'V')
            Disp = MME55.funcs.Dispersion == 'VV10';
            continue;
        elseif strcmpi(varargin{k},'alldisp')
            Disp = not(MME55.funcs.Dispersion == 'none');
            continue;
        elseif strcmpi(varargin{k},'BestVar')
            BestDisp = MME55.funcs_bestvariant(:,{'Overall_MAD','Overall_MAPD'});
            continue;
        elseif strcmpi(varargin{k},'BestDisp')
            BestDisp = MME55.funcs_bestvariant(:,{'DispOnly_MAD','DispOnly_MAPD'});
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
                TMG=find(MME55.reactions2.Reaction == varargin{k+1});
            else
                TMG=varargin{k+1};
            end
            if TMG == 11
                System = MME55.reactions.TMGroup==6;
            elseif TMG == 12
                System = MME55.reactions.TMGroup==7;
            elseif TMG == 13
                System = MME55.reactions.TMGroup==5;
            else 
                System = MME55.reactions.RNumPeriodic == TMG;
            end
            continue;
        end

        if strcmpi(varargin{k},'CS')
            Shell = MME55.reactions.Multiplicity == 1;
            continue;
        elseif strcmpi(varargin{k},'OS')
            Shell = MME55.reactions.Multiplicity > 1;
            continue;
        end

        if strcmpi(varargin{k},'RE')
            EType = MME55.reactions.EType == 1;
            ETypeMR = MME55.inclMR.reactions.EType == 1;
            continue;
        elseif strcmpi(varargin{k},'BH')
            EType = MME55.reactions.EType == 2;
            continue;
        end

        if strcmpi(varargin{k},'C')
            C = 1;
            continue;
        end

        if strcmpi(varargin{k},'tbl')
            tbl = 1;
            continue;
        end

        if strcmpi(varargin{k},'percent') | strcmpi(varargin{k},'PDs') | strcmpi(varargin{k},'PD')
            PDs = 1;
            continue;
        end
    end
end

% Decide if selecting best dispersion variant from MAD or MAPD
if PDs == 1 & istable(BestDisp) == 1
    Disp=BestDisp{:,2};
elseif istable(BestDisp) == 1
    Disp=BestDisp{:,1};
end

% Select columns from functional preferences and rows from system preferences
Tcol = DFA & Rung & Disp & Basis;
Trow = Shell & System & EType;

% Where to extract data from
if PDs == 1 
    A = MME55.percentdevs;
else
    A = MME55.devs;
end

% Give a table if ask for a table, otherwise give array
if tbl == 1
    A = A(Trow,Tcol);
else
    A = A{Trow,Tcol};
end

% Concatenate results if requested
if C == 1
    A = reshape(A,numel(A),1);
end


