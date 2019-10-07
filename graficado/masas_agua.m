function masas_agua()
L=[10.0	21	33.2	33.8
24	25	33.8	34.1
20	25	34.4	35
7.5	14.8	34.2	34.9
22	22.5	33.8	34.2];

lab={'SAW' 'TSW' 'StSW' 'ESsW' 'TrW'};

vx=[1 2 2 1 1];
vy=[3 3 4 4 3];
for k=1:numel(lab)
    x=L(k,:);
    s(k)= plot(x(vy),x(vx),'-k');
    l(k)=text(x(3),x(1),lab{k},'VerticalAlignment','bottom');
end