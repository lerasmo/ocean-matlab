function Mt=mascara_tierra(X,Y);


B=load('topografia.mat'); %Etopo2
I=B.X>=min(X(:)) & B.X<=max(X(:)) & B.Y>=min(Y(:)) & B.Y<=max(Y(:));
B.X=B.X(I);
B.Y=B.Y(I);
B.Z=B.Z(I);
%F=scatteredInterpolant(B.X(:),B.Y(:),B.Z(:),'nearest','none');
%F.Method='nearest';
%F.ExtrapolationMethod='none';
%[X Y]=meshgrid(xn,yn)


Z=griddata(B.X(:),B.Y(:),B.Z(:),X,Y,'nearest');
Mt=Z>0;