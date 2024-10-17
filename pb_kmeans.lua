return{init=function(e,e,e,e,e,e)local function t(a,o,i,n,s,h)local r,d,l=a,o,i
if h then r,d,l=h(a,o,i)end local u=math.huge local c=nil for m=1,s do local
f=n[m]local w=f[1]local y=f[2]local p=f[3]if h then w,y,p=h(w,y,p)end local
v=r-w local b=d-y local g=l-p local k=v^2+b^2+g^2 if k<=u then u=k c=m end end
return c end local function q(j,x,z,E)local T={}local A=#x local O={}for I=1,A
do T[I]={sum_red=0,sum_grn=0,sum_blu=0,c_count=0}end for N=1,z do for S=1,#j do
local H=j[S]local R=t(H[1],H[2],H[3],x,A,E)local
D=T[R]D.sum_red=D.sum_red+H[1]D.sum_grn=D.sum_grn+H[2]D.sum_blu=D.sum_blu+H[3]D.c_count=D.c_count+1
end for L=1,A do local U=T[L]local C=U.c_count local M=U.sum_red/C local
F=U.sum_grn/C local W=U.sum_blu/C U.sum_red=0 U.sum_grn=0 U.sum_blu=0
U.c_count=0 local Y=x[L]Y[1]=M Y[2]=F Y[3]=W end end return x end
return{kmeans={cluster=q,internal={find_closest_centroid=t,}}},{}end,id="PB_MODULE:kmeans",name="PB_KMeansCluster",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}