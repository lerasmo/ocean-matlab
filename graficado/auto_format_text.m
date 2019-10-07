function auto_format_text(vh,sizes)
if ~exist('vh')
    vh='h';% horizontal, portrait
end
switch vh
    case 'h' 
       % set(gcf,'paperposition',[0 0 11 8.5],'papersize',[11 8.5])
    case 'v'
       % set(gcf,'paperposition',[0 0 8.5 11],'papersize',[8.5 11])
    case ''
    otherwise
        error('No se detecta la opcion')
end

set(0,'showHiddenHandles','on');
ax=findobj('type','axes');
tx=findobj('type','text');
set(0,'showHiddenHandles','off');
if ~exist('sizes','var')
    sizes=[10 12];
end
set(ax,'fontsize',sizes(1),'fontname','book antiqua','Layer','top','box','on','FontWeight','bold')
set(tx,'fontsize',sizes(2),'fontname','book antiqua','FontWeight','bold')