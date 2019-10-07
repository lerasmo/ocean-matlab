function B=mean(R,modo,cmin)
%se hace el promedio de los cruceros
% R=mean(R,modo,|cmin|)
%modo:
%    'lances':   se calcula el perfil promedio para todo el crucero, resulta
%               en un solo perfil para cada crucero
%    'cruceros': Se calcula el perfil promedio a lo largo de todos los
%               cruceros, el resultado es un crucero tipico.
%    cmin:      Conteo minimo de datos para hacer el promedio, default 1
if ~exist('cmin','var') || isempty(cmin)
    cmin=1;
end

switch lower(modo)
    case 'lances'
        B=[];
        for k=1:numel(R)
            dum=meanL(R(k));
            if isempty(dum)
                continue
            end
            B=[B;dum];
        end
    case 'cruceros'
        B=meanC(R);
    otherwise
        error('El tipo debe ser ''lances'' o ''cruceros''');
end
%Reordenar los lances y las estaciones



    function B=meanL(R)
        %promediar por cada profunidad dentro del mismo crucero para obtener un
        %lance promedio.
        
        
        B=OceanographicCampaign;
        B.Crucero=[R.Crucero,' Lance Promedio'];
        B.Lances=1;
        B.nLances=1;
        B.linest={'promedio'};
        B.fecha=mean(R.fecha);
        B.lat=mean(R.lat);
        B.lon=mean(R.lon);
        B.linea=0;
        B.estacion=0;
        B.Variables=R.Variables;
        B.userdata.nota=['Perfil promedio del crucero ',R.Crucero];
        
        vp=R.vars_index('presion');
        
        if isempty(R.data)
            B=[];
            return;
        end
        [M, Nv]=meancell(R.data,vp);
        if isempty(M)
            B=[];
            return;
        end
        B.data{1}=M;
        B.userdata.conteo=Nv;
    end

    function B=meanC(R)
        %promediar diferentes lances de varios cruceros para obtener un crucero
        %promedio
        G.linest=lower(cat(1,R.linest));
        G.fecha=(cat(1,R.fecha));
        G.lat=(cat(1,R.lat));
        G.lon=(cat(1,R.lon));
        G.linea=(cat(1,R.linea));
        G.estacion=(cat(1,R.estacion));
        
        LEu=unique(G.linest);
        G.vars={};
        for k=1:numel(R)
            G.vars=[G.vars;repmat({R(k).Variables(:)},R(k).nLances,1)];
        end
        G.data=cat(1,R.data);
        
        B=OceanographicCampaign;
        B.Variables=unique(cat(1,R.Variables),'stable');
        
        c=0;
        %recortar las sobras
        LEu(~cellfun(@isempty,strfind(LEu,'999')))=[];
        LEu(~cellfun(@isempty,strfind(LEu,'99.99')))=[];
        LEu(~cellfun(@isempty,strfind(LEu,'nan')))=[];
        
        c=1;
        for k=1:numel(LEu)
            
            I=find(strcmp(LEu(k),G.linest));
            if all(isnan(G.linea(I))) | numel(I)<=cmin
                continue
            end
            
            %disp(LEu{k})
            
            dum=G.data(I);
            %vp=R(1).vars_index('presion'); %puede generar errores si la posicion de la columna de presion cambia
            vp=1;
            
            
            
            
            [dum, nv]=meancell(dum,vp,G.vars(I),B.Variables);
            if isempty(dum)
                continue
            end
            B.fecha(c,1)=nanmean(G.fecha(I));
            B.lat(c,1)=nanmean(G.lat(I));
            B.lon(c,1)=nanmean(G.lon(I));
            B.data{c,1}=dum;
            B.linea(c,1)=unique(G.linea(I));
            try
            B.estacion(c,1)=unique(G.estacion(I));
            catch
                error(LEu{k})
            end
           
            B.linest{c,1}=LEu{k};
            c=c+1;
        end
        
        B.Crucero='Promedio';
        B.nLances=numel(B.data);
        B.Lances=1:B.nLances;
        
        % keyboard
    end
    function [M, Nv]=meancell(data,vp,vars,vout)
        if ~exist('vars','var')
            %revisar que data sea consistente
            sz=cellfun(@size,data,'UniformOutput',false);
            sz=cat(1,sz{:});
            if any(sz(1,2)~=sz(:,2))
                error('dimensiones de variables no consistentes')
            end
            sz=sz(1,2);
            vout='A':'z';
            vout=vout(1:sz);
            vout=mat2cell(vout,1,ones(1,sz));
            vars=repmat({vout},numel(data),1);
            
        end
        
        for c=1:numel(data)
            mx(c)=max(data{c}(:,vp));
        end
        
        mx=max(mx);
        P=[1:mx(vp)]';
        
        
        M=nan(numel(P),numel(vout),numel(data));
        Nv={};
        for cn=1:numel(data)
            
            dum=data{cn};
            p=dum(:,vp);
            [~,Ia ,Ib]=intersect(P,p);
            [~,Ja ,Jb]=intersect(vout,vars{cn});
            M(Ia,Ja,cn)=dum(Ib,Jb);
            
            %keyboard
            
        end
        Nv=sum(~isnan(M),3);
        M=nanmean(M,3);
        M(Nv<cmin)=nan;
        I=all(isnan(M),2);
        M(I,:)=[];
        Nv(I,:)=[];
        %Nv=Nv(:,1);
    end
end
