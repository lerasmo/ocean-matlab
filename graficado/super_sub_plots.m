function ax=super_sub_plots(x,y,ind)

if nargin==2
    ind=y;
    y=x;
end
    


n=numel(x)*numel(y);
x=x./sum(x);
y=y./sum(y);


    k=1;

for j=1:numel(y)
    x0=0;
    y0=sum(y((j+1):end));

    for i=1:numel(x)
        
        op=[x0 y0 x(i) y(j)];
        if k==ind
            ax=axes('OuterPosition',op);
            return
        end
        k=k+1;
        x0=x0+x(i);
    end
    
    %return
end

