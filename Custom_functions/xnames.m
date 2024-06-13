function N = xnames(MME55,varargin)
%--------------------------------------------------------------------------
% EXTRACT SPECIFIC FUNCTIONAL NAMES FROM MME55 DATA STRUCTURE
% Created by D. Wappett (2023)
%--------------------------------------------------------------------------
% Required inputs:
%   MME55: data struct with MME55.funcs functional categorisation table
% Options:
%   Specify functional: 'func' then name of func
%   Rung of Jacob's ladder: 'G' 'M' 'H' 'DH'
%   Dispersion correction: 'U' 'D3' 'D4' 'V' 'AllDisp' 'BestDisp' 'BestVar'
%   Basis set: 'DZ' 'TZ' 'QZ' '3c' 'nosmallbasis'
%   Output type: 'Functional' 'Rung' 'Dispersion' 'FuncBasis', 'log'=logical
%--------------------------------------------------------------------------

% set up defaults
DFA = ones(numel(MME55.funcs.Functional),1);
R = ones(numel(MME55.funcs.Rung),1);
Disp = ones(numel(MME55.funcs.Dispersion),1);
B = ones(numel(MME55.funcs.BasisSet),1);
type = 'Name';
logout = 0;

% read inputs
if nargin>1
    for k=1:length(varargin)
        if strcmpi(varargin{k},'G')
            R = MME55.funcs.Rung == 'GGA';
            continue;
        elseif strcmpi(varargin{k},'M')
            R = MME55.funcs.Rung == 'meta-GGA';
            continue;
        elseif strcmpi(varargin{k},'H')
            R = MME55.funcs.Rung == 'hybrid';
            continue;
        elseif strcmpi(varargin{k},'DH')
            R = MME55.funcs.Rung == 'double hybrid';
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
        elseif strcmpi(varargin{k},'AllDisp')
            Disp = not(MME55.funcs.Dispersion == 'none');
            continue;
        elseif strcmpi(varargin{k},'BestDisp')
            Disp = MME55.funcs_bestvariant.DispOnly_MAD;
            continue;
        elseif strcmpi(varargin{k},'BestVar')
            Disp = MME55.funcs_bestvariant.Overall_MAD;
            continue;
        elseif strcmpi(varargin{k},'BestDispPD')
            Disp = MME55.funcs_bestvariant.DispOnly_MAPD;
            continue;
        elseif strcmpi(varargin{k},'BestVarPD')
            Disp = MME55.funcs_bestvariant.Overall_MAPD;
            continue;
        end

        if strcmpi(varargin{k},'DZ')
            B = MME55.funcs.BasisSet == 'def2-SVP';
            continue;
        elseif strcmpi(varargin{k},'TZ')
            B = MME55.funcs.BasisSet == 'def2-TZVPP';
            continue;
        elseif strcmpi(varargin{k},'QZ')
            B = MME55.funcs.BasisSet == 'def2-QZVPP';
            continue;
        elseif strcmpi(varargin{k},'3c')
            B = MME55.funcs.BasisSet == '3c';
            continue;
        elseif strcmpi(varargin{k},'nosmallbasis')
            B = MME55.funcs.BasisSet == 'def2-QZVPP' | MME55.funcs.BasisSet == '3c';
            continue;
        end

        if strcmpi(varargin{k},'func')
            DFA = MME55.funcs.Functional == varargin{k+1};
            continue;
        end

        if strcmpi(varargin{k},'Functional')
            type = 'Functional';
            continue;
        elseif strcmpi(varargin{k},'Rung')
            type = 'Rung';
            continue;
        elseif strcmpi(varargin{k},'Dispersion')
            type = 'Dispersion';
            continue;
        elseif strcmpi(varargin{k},'FuncBasis')
            type = 'FuncBasis';
            continue;
        end
        
        if strcmpi(varargin{k},'log')
            logout=1;
            continue;
        end
    end
end

% Select rows of func table based on selection
Frow = DFA & R & Disp & B;

% Determine what output type to use
if logout==1
    N=Frow;
else
    N = MME55.funcs{Frow,type};
end

