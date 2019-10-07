function trim_image(file)
fileo=file;
str=['magick "',file,'" -define trim:percent-background=99% -trim "',fileo,'"'];
dos(str);