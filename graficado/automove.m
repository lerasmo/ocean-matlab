function automove(h)
global h id
id=0;
set(gcf,'WindowButtonDownFcn',@down,'WindowButtonMotionFcn', @move,	'WindowButtonUpFcn', @up)

function down(fig,a)
global h ns id
M=get(gca,'currentPoint');
cpx=M(1,1);
cpy=M(1,2);
X=get(h,'XData')';
Y=get(h,'YData')';

d=((X-cpx).^2+(Y-cpy).^2).^0.5;
ns=find(d==min(d));
id=1;



%seleccionar el punto

function move(varargin)
global h ns id
if ~id; return; end
M=get(gca,'currentPoint');
cpx=M(1,1);
cpy=M(1,2);
X=get(h,'xData')';
Y=get(h,'yData')';
X(ns)=cpx;Y(ns)=cpy;
set(h,'xData',X,'Ydata',Y);
drawnow;

%moverlo

function up(varargin)
global h ns id
id=0;
ns=nan;
%soltarlo


	
	
	