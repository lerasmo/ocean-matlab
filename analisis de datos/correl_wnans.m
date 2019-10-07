function [c,nupars,tao] = correl_wnans(x,y,lags)
% A 'normalized' version of  laged_cova0_wnans(x,y,lags)
% calculates the 'laged correlation' from -lags to lags

x=x(:); 
y=y(:);% co~no, mas vale que inicien de igual long.
n=length(x);
x=x-nanmean(x);
y=y-nanmean(y);% medio sucia, la quitada de media.
c=[];
nupars=[];
for kl=-lags:lags
    % para lags<=0 la serie x va de 1 hasta n+lag: se desplaza la serie x a la
    % derecha. Por lo tanto, si la correlación máxima da en un lag negativo la
    % serie x antecede a y. Para lag>0 la serie x va de 1+lag a n, por lo tanto
    % la serie x se desplaza a la izquierda  y "y" antecede a x.
    ksx=max(kl+1,1);
    kex=min(n,n+kl);
    % para lags<=0 la serie y va de 1+lag hasta n, por lo tanto la serie y se
    % desplaza a la izquierda y si la correlacion máxima se da en lag negativo, x
    % antecede a y. Para lags>0, y va de 1 hasta n-lag lo que equivale a
    % desplazarla a la derecha, asi que si la máxima correlacion se da para
    % lag>0 entonces y antecede a x.
    ksy=max(1,-kl+1);
    key=min(n,n-kl);
    xm=x(ksx:kex);
    ym=y(ksy:key);
    a=xm.*ym;
    ii=find(isnan(a));
    a(ii)=[];
    
    nu=length(a);
    nupars=[nupars nu];
    
    if nu;%length(ii);
        %c=[c sum(a)/length(a)];   ===!! see laged_cova0_wnans
        xm(ii)=[];
        ym(ii)=[];
        xm=xm'*xm;
        ym=ym'*ym;
        c=[c sum(a)/sqrt(xm*ym)];%   NORMALIZATION , sort of 'too much ad hoc'
    else
        c=[c NaN];
    end
end
c=c(:);
tao=-lags:lags;
tao=tao(:);