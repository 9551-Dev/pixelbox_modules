return{init=function(e,e,e,e,e,e)local function t(a,o,i)local
n=(a*0.4122214708+o*0.5363325363+i*0.0514459929)^0.3333333 local
s=(a*0.2119034982+o*0.6806995451+i*0.1073969566)^0.3333333 local
h=(a*0.0883024619+o*0.2817188376+i*0.6299787005)^0.3333333 return
n*0.2104542553+s*0.7936177850-h*0.0040720468,n*1.9779984951-s*2.4285922050+h*0.4505937099,n*0.0259040371+s*0.7827717662-h*0.8086757660
end local function r(d,l,u)if d>0.04045 then d=((d+0.055)/1.055)^2.4 else
d=d/12.92 end if l>0.04045 then l=((l+0.055)/1.055)^2.4 else l=l/12.92 end if
u>0.04045 then u=((u+0.055)/1.055)^2.4 else u=u/12.92 end return
d*0.4124+l*0.3576+u*0.1805,d*0.2126+l*0.7152+u*0.0722,d*0.0193+l*0.1192+u*0.9505
end local c=16/116 local function m(f,w,y)local p,v,b=r(f,w,y)local g=p/94.811
local k=v/100 local q=b/107.304 if g>0.008856 then g=g^0.3333333 else
g=7.787*g+c end if k>0.008856 then k=k^0.3333333 else k=7.787*k+c end if
q>0.008856 then q=q^0.3333333 else q=7.787*q+c end
return(16*k)-16,50*(g-k),20*(k-q)end local function j(x,z,E)return x,z,E end
return{cspace={cielab=m,oklab=t,rgb=j,xyz=r,}},{}end,id="PB_MODULE:cspace",name="PB_ColorSpace",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}