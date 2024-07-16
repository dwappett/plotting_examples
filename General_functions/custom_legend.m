function lgd = custom_legend(labels, colours, type, options)
%--------------------------------------------------------------------------
% Make custom legend
% D. Wappett (2024)
%--------------------------------------------------------------------------
% Required inputs:
%   labels: string array Nx1 or 1XN
%   colours: Nx3 RGB colour matrix
%   type: "bar"/"b" or "scatter"/"s"
% Optional inputs:
%   options: structure of general legend options eg font options, location, orientation, etc
%--------------------------------------------------------------------------

%% define legend properties from input options and/or defaults

defopt=["Orientation" "vertical"; "Location" "eastoutside"; "Interpreter" "none"];

for i=1:length(defopt)
    if ~isfield(options,defopt(i,1))
        options.(defopt(i,1))=defopt(i,2);
    end
end

%% make the placeholder plots

obj=[];

hold on
for i=1:length(labels)
    if strcmpi(type,"bar") || strcmpi(type,"b")
        p{i}=bar(1,NaN,0.8,'FaceColor','flat','EdgeColor','flat','CData',colours(i,:));
        obj=[obj p{i}];
    elseif strcmpi(type,"scatter") || strcmpi(type,"s")
        p{i}=scatter(1,NaN,80,colours(i,:),"filled","o");
        obj=[obj p{i}];
    end
end

%% make the legend for the placeholders

lgd=legend(obj,labels,"AutoUpdate","off");
set(lgd,options)
