function savefigs(direc,filetype,dpi)
% savefigs(direc,filetype,dpi) 
%
% Saves all open figures in directory direc according to their figure
% names. filetype specifies a file type ('png','fig', or 'eps'). dpi sets
% the resolution in dpi for png files. The dpi argument is ignored if the
% filetype is not 'png'.

if nargin < 1
    direc = [];
end
if nargin < 2
    filetype = 'png';
end
if nargin < 3
    dpi = 0;
end

if isempty(direc)
    direc = [pwd filesep];
end

if nargin >= 1
    if ~strcmp(direc(end),filesep)
        direc = [direc filesep];
    end
end

% Create the directory, if it does not exist
if ~exist(direc,'dir')
    mkdir(direc)
end

% Set dpi string
if strcmp(dpi, 'low')
    savemethod = 'saveas';
else
    savemethod = 'print'; % Doesn't do anything, just needs to not be 'saveas'
    dpi = num2str(dpi);
end

% Get all figure handles
h = get(0,'children');

% Save each figure
for i=1:length(h)
    % Save to file named after figure, or generate a name if the figure
    % name is empty
    figname = get(h(i),'Name');
    if isempty(figname)
        figname = ['Figure' num2str(getFigureNumber(h(i)))];
    end
    % Remove invalid characters and replace with underscores
    figname = regexprep(figname, '[,:\.]', '_');
    %saveas(h(i), [direc get(h(i),'Name')], 'png');
    switch filetype
        case 'png'
            switch savemethod
                case 'saveas'
                    hgexport(h(i), [direc figname '.png'], hgexport('factorystyle'), 'Format', 'png'); 
                otherwise
                    print(h(i),'-dpng',['-r' dpi],[direc figname '.png'])
            end
        case 'fig'
            saveas(h(i),[direc figname '.fig'],'fig')
        case 'eps'
            print(h(i),'-depsc',[direc figname])
    end
end

    function figno = getFigureNumber(h)
        % This is functionalized because different versions of MATLAB
        % require different methods.
        MATLABversion = ver('MATLAB');
        MATLABversion = str2double(MATLABversion.Version);
        if MATLABversion >= 8.4
            figno = [h.Number];
        else
            figno = h;
        end
    end

end