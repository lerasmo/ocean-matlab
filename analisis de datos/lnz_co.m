function [h,Fh,Rh]=lnz_co(fo,fc,fn,s,df);
% INPUT:
% [h,Fh,Rh]=lnz_co(fo,fc,fn,s,df);
% fo = frecuencia central del filtro
% fc = frecuencia de corte (al 50% de la señal)= medio ancho de banda del filtro.
% fn = frecuencia de Nyquist de los datos que se van a filtrar.
%  s = El número total de coeficientes es (s+1+s). Con esta definicion
%       aseguramos que le número total de coeficientes sea impar. Esto significa
%       que el filtro no cambia la fase de la señal filtrada.
% df = 1/(N*dt) de los datos que vamos a filtrar
 %df equivale: fs/N
% OUTPUT

% h = coeficientes del filtro Lanczos en el dominio del tiempo

%************************************************************* 
Fh=[]; Rh=[];
delta = 4*fn/(2*s+1); % ancho de banda de transición

% este valor debe ser menor que 1
chk=delta/(2*fc);
%s=((2*fn/fc)-1)/2
if chk >=1
    warning('El filtro se esta superponiendo en el origen')
    %s=((2*fn/fc)-1)/2;
end

n= -s : s;
%Cn=sin(pi*n*fc/fn)./(pi*n);  %coeficientes de Fourier del pulso cuadrado.
                              %esta operación da una división por cero pero
                              %no te asustes, se evalua con la funcion sinc.
Cn=(fc/fn)*sinc(n*fc/fn); % esta es la misma pero no da division por cero

%Sigma=sin(2*pi*n/(2*s+1))./(2*pi*n/(2*s+1)); %factores de Lanczos, division por cero
Sigma=sinc(2*n/(2*s+1)); % lo mismo pero sin division por cero
%Co=fc/fn;

h=Cn.*Sigma; % ya tenemos los coeficientes del filtro pasa bajas.

                  
%*************
if abs(fo) > 0
 banda=cos(2*pi*n*fo/(2*fn));
 h=2*h.*banda;
end
%*************

% Por comodidad generamos la respuesta en frecuencia del filtro.

 Fh=-fn:df:fn; Fh=Fh';
% for k=1:length(Fh);
% Rh(k)=sum( h.*cos( 2*pi*n*Fh(k)/(2*fn) ) );
% end;
% 
xdum=length(Fh); ydum=length(n);
A = zeros(xdum,ydum);
dum=2*pi/(2*fn);
A = cos(dum*Fh*n);

N=length(h);
h=reshape(h,N,1);

Rh = A*h;
