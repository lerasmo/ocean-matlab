function [xy, n, x]=reducir_segmentos(xy);

if iscell(xy)
    x=xy;
    xy=[];
    for k=1:numel(x);
        if numel(x{k})>3
        xy=[xy;[nan nan];x{k}];
        end
    end
    clear('x');
end
b=find(~isnan(xy(:,1)),1);
e=find(~isnan(xy(:,1)),1,'last');
xy=xy(b:e,:);
I=[0 ;find(isnan(xy(:,1))); size(xy,1)+1];
j=0;
costa=[]; isla=[];
for k=1:numel(I)-1
    x(k)={xy(I(k)+1:I(k+1)-1,:)};
    % xi yi xf yf num
    [D,~,c]=unique(x{k},'rows');
    x{k}=D(c,:);
    %keyboard
    
    S=[x{k};x{k}(1,:)];
    
    D=sum(diff(S).^2,2).^0.5;
    if max(D)~=D(end) & D(end)~=0
        %    plot(S(:,1),S(:,2),'.-')
        %pause
        c=find(D==max(D));
        x{k}=[x{k}(c+1:end,:);x{k}(1:c,:) ];% invertir
    end
    if D(end)==0
        isla=[isla x(k)];
    elseif max(D)<2*std(D) %isla
        isla=[isla {x{k}([1:end 1],:)}];
    else %costa
        j=j+1;
        costa=[costa x(k)];
        E(j,1:5)=[x{k}(1,:) x{k}(end,:) size(x{k},1) ];
    end
    
    
end
x=costa;

[~,I]=sort(E(:,end),'descend');
E=E(I,:);
x=x(I);

xo={};
c=1;

while 1
    D=[];
    p=0;
    n=[];
    f=[];
    % casos
    
    D(:,1)=((E(c,3)-E(:,1)).^2 + (E(c,4)-E(:,2)).^2 ).^0.5;% Fin Prin
    D(:,2)=((E(c,3)-E(:,3)).^2 + (E(c,4)-E(:,4)).^2 ).^0.5;% Fin Fin
    D(:,3)=((E(c,1)-E(:,3)).^2 + (E(c,2)-E(:,4)).^2 ).^0.5;% Prin Fin
    D(:,4)=((E(c,1)-E(:,1)).^2 + (E(c,2)-E(:,2)).^2 ).^0.5;% Prin Prin
    
    D(c,:)=inf;
    [n p]=find(D<=.1);
    I=find(E(n,5)==max(E(n,5)),1);
    n=n(I);
    p=p(I);
    
    %keyboard
    
    if ~isempty(p)
        switch p
            case 1 % pegar directamente al final
                x{c}=[x{c};x{n}];
            case 2 % voltear la segunda parte y pegar al final
                x{c}=[x{c};x{n}(end:-1:1,:)];
            case 3 % pegar al principio
                x{c}=[x{n};x{c}];
            case 4 % voltear la segunda parte y pegar al principio
                x{c}=[x{n}(end:-1:1,:);x{c}];
            otherwise
        end
        
        %se quita el que se pego
        I=[1:numel(x)]' ~= n;
        x=x(I);
        E=E(I,:);
%         %se ordenan
%          [~,I]=sort(E(:,end),'descend');
%          E=E(I,:);
%          x=x(I);
        if c<size(E,1)
            E(c,1:5)=[x{c}(1,:) x{c}(end,:) size(x{c},1) ];
        else
            break
        end
        
    else
        c=c+1;
        if c>numel(x)
            break
        end
    end
end



%[~, I]=sort(cellfun(@(x) size(x,1),isla)','descend');
x=[x isla];
xy=x{1};
sx=cellfun(@numel,x);
[~ ,I]=sort(sx,'descend');
x=x(I);
for k=1:numel(x);
    xy=[xy;[nan nan];x{k}];
end
n=numel(x);
