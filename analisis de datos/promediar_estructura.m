function P=promediar_estructura(S,mode,func)
%clc
%clear all
%close all
%load waves_marvan_2019.mat

[vars ,I,fn ]=get_datavars(S);
fn=fn(~I);
fn(strcmp(fn,'jd'))=[];
fi=datevec(min(S.jd)+3);

if ~exist('mode','var')
    mode='dia';
end
if ~exist('func','var')
    func=@nanmean;
end
if isnumeric(mode)
    v=S.jd(1);
    I=mode;
elseif ischar(mode)
    switch mode
        case 'mes'
            fi(3)=1;
            fi([4:end])=0;
            r=2;
        case 'dia'
            fi([4:end])=0;
            r=3;
        case 'hora'
            fi([5:end])=0;
            r=4;
            
    end
    v=datenum(fi);
    I=[0 0 0 0 0 0];
    I(r)=1;
    P.jd=v;
end



c=1;
Bp=[];
while v(end)<max(S.jd)
    c=c+1;
    if ischar(mode)
        fi=fi+I;
        
        v(c)=datenum(fi);
        Is=S.jd>=v(c-1) & S.jd<v(c);
        
    else
        Is=((c-2)*mode+1):(c-1)*mode;
        if Is(end)>numel(S.jd)
            break
        end
        v(c-1)=nanmean(S.jd(Is));
        
        %keyboard
    end
    
   
    %datestr(v(c-1))
    for k=1:numel(vars)
        if any(size(S.(vars{k}))==1)
            P.(vars{k})(c-1)=func(S.(vars{k})(Is));
        else
            [~,s]=max(size(S.(vars{k})));
            switch s
                case 1
                     P.(vars{k})(c-1,:)=func(S.(vars{k})(Is,:));
                case 2
                    P.(vars{k})(:,c-1)=func(S.(vars{k})(:,Is),2);
               
                    
            end
            
        end
        
        
        
    end
    %clf
    %plot(Is)
    %pause
    
end
%P.jd=0.5*(v(1:end-1)+v(2:end));
if ischar(mode)
    
    P.jd=v(1:end-1);
else
    P.jd=v;
end

%% Bypass
for k=1:numel(fn)
    P.(fn{k})=S.(fn{k});
end
 

P = orderfields(P, S);
%plot(S.jd,S.Hs)
%hold on
%plot(P.jd,P.Hs,'r')


%datestr(v)





