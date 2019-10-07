function  R=index(A,I)

R=A;
fd={'Lances'
    'linest'
    'fecha'
    'lat'
    'lon'
    'linea'
    'estacion'
    'data'         };

for k=1:numel(fd)
    R.(fd{k})=R.(fd{k})(I);
end
R.nLances=numel(R.Lances);
