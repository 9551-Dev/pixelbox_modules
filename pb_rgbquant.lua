return{init=function(e,t,a,o,o,i)local n local function s(h,r,d,l,u)if u then
r,d,l=u(r,d,l)end local c=math.huge local m=nil for f=1,#h do local
w=h[f].color local y,p,v=w.r,w.g,w.b if u then y,p,v=u(y,p,v)end local b=y-r
local g=p-d local k=v-l local q=b^2+g^2+k^2 if q<=c then c=q
m=h[f].palette_index end end return m end local function j(x,z,E,T,A)local
O=n.create_multilayer_list(2)local I={}for N=1,#x do local
S=x[N]I[S.palette_index]=N end for H=0,z do for R=0,E do for D=0,T do local
L=H/z local U=R/E local C=D/T O[H][R][D]=s(x,L,U,C,A)end end end
O.r_upper_bound=z O.g_upper_bound=E O.b_upper_bound=T O.source_palette=x
O.reverse_map=I return O end local function M(F,W,Y,P)local V=W*F.r_upper_bound
local B=Y*F.g_upper_bound local G=P*F.b_upper_bound V=V-V%1 B=B-B%1 G=G-G%1
return F[V][B][G]end local function K(Q,J,X,Z)local et=J*Q.r_upper_bound local
tt=X*Q.g_upper_bound local at=Z*Q.b_upper_bound et=et-et%1 tt=tt-tt%1
at=at-at%1 local ot=Q[et][tt][at]return
Q.source_palette[Q.reverse_map[ot]].color end local function
it(nt,st,ht,rt,dt)if not st then st=math.sqrt(#nt)*2 end if not ht or not rt
then ht=st rt=st end return j(nt,st,ht,rt,dt)end
return{rgbquant={from_rgb=M,idx_from_rgb=M,rgb_from_rgb=K,make_colorspace=it,internal={pythagorean_quantize=s,generate_lookup_space=j,}}},{verified_load=function()if
not e.modules["PB_MODULE:arrutil"]then
a.module_error(t,"Missing dependency PB_MODULE:arrutil",3,i.supress)end
n=e.modules["PB_MODULE:arrutil"].__fn.arrutil
end}end,id="PB_MODULE:rgbquant",name="PB_RGBQuantizer",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}