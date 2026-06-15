function varargout = custom_legend(labels, colours, type, options)
%--------------------------------------------------------------------------
% Make custom legend
% D. Wappett (2024)
%--------------------------------------------------------------------------
% Required inputs:
%   labels: string array Nx1 or 1XN
%   colours: Nx3 RGB colour matrix
%   type: "bar"/"b" or "scatter"/"s"
%   options: structure of general legend options pr [] if you just want the defaults set below
%       (if using SetPlotDefaults, you could define legend options structure in there too to clean up main plotting script!)
%--------------------------------------------------------------------------
% Outputs:
%   Standard legend outputs [lgd,icons,obj,str]
%   Use lgd=custom_legend(...) to just get legend
%   or [lgd,icons]=custom_legend(...) if you're also using scale_lgd_icons
%--------------------------------------------------------------------------

%% define legend properties from specified input options and/or defaults

% get the default font settings from the plot itself
ax=gca;

defopt=["Orientation" "vertical"; "Location" "eastoutside"; "Interpreter" "none"; "FontSize" ax.FontSize; "FontWeight" ax.FontWeight; "FontName" ax.FontName];

for i=1:length(defopt)
    if ~isfield(options,defopt(i,1))
        if strcmpi(defopt(i,1),"FontSize") % the array above makes the fontsize value a string, need to convert back to numeric value
            options.(defopt(i,1))=str2num(defopt(i,2));
        else
            options.(defopt(i,1))=defopt(i,2);
        end
    end
end

%% make the placeholder plots

Npts=length(labels);
plts=[];

hold on
for i=1:Npts
    if strcmpi(type,"bar") || strcmpi(type,"b")
        p{i}=bar(1,NaN,0.8,'FaceColor','flat','EdgeColor','flat','CData',colours(i,:));
        plts=[plts p{i}];
    elseif strcmpi(type,"scatter") || strcmpi(type,"s")
        p{i}=scatter(1,NaN,80,colours(i,:),"filled","o");
        plts=[plts p{i}];
    end
end

%% make the legend for the placeholders

[lgd,icons,obj,str]=legend(plts,labels,"AutoUpdate","off");
set(lgd,options)

%% define output variables
varargout{1}=lgd;
varargout{2}=icons;
varargout{3}=obj;
varargout{4}=str;
