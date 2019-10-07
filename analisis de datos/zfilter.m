function [z, dz, med,cnt]=zfilter(v,n,gpu)
%clear all
%close all
%clc
%v=1:10;
%n=5;

[r, c]=size(v);

if exist('gpu','var') 
    gpu=lower(gpu);
    switch gpu
        case 'cpu'
            gpu=false;
        case 'gpu'
            if gpuDeviceCount
                disp('Corriendo en modo GPU')
                gpu=true;
            else
                warning('Se selecciono GPU, pero no esta disponible. Se procesa en CPU')
                gpu=false;
            end
        otherwise
            error('Las opciones son ''gpu'' o {''cpu''}')
            
    end
else% auto
    %if gpuDeviceCount
    %     disp('Corriendo en modo GPU')
    %     disp('agregue la opcion ''cpu'' para correr desde el procesador')
    %     gpu=true;
    %else
        gpu=false;
    %end
end

if c>r
    %a lo largo de renlones
    v=v';
    [r c]=size(v);
end

if ~mod(n,2)
    error('N debe ser non')
    
end

n2=n/2-0.5;
S=memory;
if  numel(v)*n < 0.4*(S.MemAvailableAllArrays/8) %6e8 %exeso de dimensiones
    
    
    
    M=nan(r,c,n);
    if gpu
           M=gpuArray(M);
           v=gpuArray(v);
    end
    sh=-n2:n2;
    
    for k=1:n
        I=(1:r)+sh(k);
        Im=I>0 & I<=r;
        I=I(Im);
       % try
            M(Im,:,k)=v(I,:);
       % catch
       %     keyboard
       % end
        
        %I=(1:numel(v))+sh(k);
        %M(Im,k)=v(I);
    end
    
    med=nanmean(M,3);
    cnt=sum(~isnan(M),3);
    
    dz=v-med;
    try
        st=nanstd(M,[],3);
    catch
        disp('Sin memoria')
        keyboard
    end
    z=dz./st;
    
else
    disp('modo eco-memory')
    z=nan(size(v));
    dz=z;
    med=z;
    cnt=z;
    std=z;
    prc=numel(v)/100;
    c=0;
    if  exist('parfor','builtin')
        disp('Usando paralelizacion')
        parfor k=1:numel(v)
            pin=max([1 k-n2]);
            pif=min([numel(v) k+n2]);
            I=pin:pif;
            chnk=v(I);
            med(k)=nanmean(chnk);
            std(k)=nanstd(chnk)
            
            %c=c+1;
            %if c>prc
            %    fprintf('|')
            %    c=0;
            %end
        end
        dz=v-med;
        z=dz./std;
    else
        disp('Paralelizacion no disponible :(')
        disp('Haciendolo a la mala')
        for k=1:numel(v);
            pin=max([1 k-n2]);
            pif=min([numel(v) k+n2]);
            I=pin:pif;
            chnk=v(I);
            dz(k)=v(k)-nanmean(chnk);
            z(k)=dz(k)./nanstd(chnk);
            %c=c+1;
            %if c>prc
            %    fprintf('|')
            %    c=0;
            %end
        end
    end
    
    
end
%whos
%toc