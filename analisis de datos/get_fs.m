function fs=get_fs(jd)

fs1=1./mode(diff(jd));
fs2=1./nanmean(diff(jd));
if round(fs1)==round(fs2)
    fs=round(fs1);
else
   d=[abs(fs1-round(fs1)),abs(fs2-round(fs2))];
   i=near(d,0);
   if i==1
       fs=fs1;
   else
       fs=fs2;
   end
end
fs=round(fs);
