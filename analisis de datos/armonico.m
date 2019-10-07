% analisis armonico
function [a,b,z]=armonico(t,h,sigma,t2)

%INPUT
% sigma =  frecuencias a resolver (vector fila)
% t = vector tiempo;
% h = vector de datos (vectores columna);
% t2 = Vector de tiempo a evaluar (igual a t por default)
%OUTPUT
% z = predicion o ajuste a los datos h
% a = ampliudes
% b = fases

a=[];b=[];z=[];
h=h(:);
sigma=sigma(:);
t=t(:);
if exist('t2','var')
    t2=t2(:);
else
    t2=t;
end


h = h - mean(h); % se elimina promedio
k = length(sigma); n = length(h);
A = zeros(n,2*k);

for j  = 1 : k
    
    A(:,j) = cos( 2*pi*sigma(j) * t );
    
    
    
end

for j  = 1 : k
    A(:,j+k) = sin(2*pi*sigma(j) * t);
end

B = pinv(A) * h;

x = B(1:k);
y = B(k+1:2*k);

for j = 1 : k
    a(j) = sqrt(x(j)*x(j) + y(j)*y(j)); %amplitud, vector fila
    b(j) = atan2( y(j), x(j) ); %fase, vector fila
end

a=a'; b=b';

for j = 1 : numel(t2)
    z(j) = sum( a.*cos(2*pi*sigma * t2(j) - b) );
    %z = sum( a.*cos(2*pi*sigma.* t2 - b) );
end

b=b*180/pi;  % fase a grados