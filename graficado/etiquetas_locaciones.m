function ht=etiquetas_locaciones(mrot)
if ~exist('mrot','var')
    %     a=30.1443;
    %     rot=[cosd(a) -sind(a)
    %         sind(a) cosd(a)];
    %     st=[cosd(30) 0
    %         0  1];
    %     mrot=st*rot;
    mrot=eye(2);
end
%auto_map([-122  -108    20    34])

loc=[-116.6369   31.9118
    -115.9717   30.5588
    -118.2206   29.1380
    -115.2177   28.1827
    -117.1625 32.7150
    -122.433333 37.766667
    -118.25 34.05,
     -114.7262   27.6589
 -111.7491   24.6860
 -109.9383   22.9871
  -113.5946   26.9459];

loc2=loc*mrot;
locs={'Ensenada'
    'San Quintin'
    'Isla Guadalupe'
    'Isla de Cedros'
    'San Diego'
    'San Francisco'
    'Los Angeles'
    'Punta Eugenia'
    'Bahia Magdalena'
    'C.S.L'
    'Punta Abreojos'};
[xl yl]=lims2rect;
I=inpolygon(loc2(:,1),loc2(:,2),xl,yl);

ht=text(loc2(I,1)+0.01,loc2(I,2)-.12,locs(I),'FontWeight','bold');
%san diego 32°42?54?N 117°09?45?O
%SF 37.766667_N_-122.433333