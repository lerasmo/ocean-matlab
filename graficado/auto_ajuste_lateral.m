function auto_ajuste_lateral(L)
R=get(gcf,'Position');
a0=get(gca,'CameraViewAngle');
 ancho=get(0,'ScreenSize');
while 1
    
    R(3)=R(3)-1;
    R(1)=ancho(3)-R(3);
    set(gcf,'Position',R);
    
    an=get(gca,'CameraViewAngle');
    if an~=a0 | R(3)<L
        R(3)=R(3)+1;
        set(gcf,'Position',R)
        break
    end
    
end