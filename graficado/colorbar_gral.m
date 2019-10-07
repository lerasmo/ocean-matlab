function hcb=colorbar_gral(ax);

if ~exist('ax','var')
    
    
    ax=gca;
end
P1=ax.Position;


hcb=colorbar(ax);

ax.Position=P1;

P=hcb.Position;
x=P(1);
y=P(2);
dx=P(3);
dy=0.85;
y=(1-dy)/2;
P=[ x y dx dy ];
hcb.Position=P;
cb=hcb;
%cb.Position(2)=ax(4).Position(2)+ax(4).TickLength(1);
%cb.Position(4)=ax(2).Position(2)+ax(2).Position(4)-ax(4).Position(2)-2*ax(4).TickLength(1);