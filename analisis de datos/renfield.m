function D=renfield(D,old,new)
%renombra un campo de estructura

%erasmo julio 2018

D.(new)=D.(old);
D=rmfield(D,old);

