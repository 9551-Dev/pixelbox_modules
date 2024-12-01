return{init=function(e,t,a,o,o,i)local n,s local h=table.concat local
r=a.internal.to_blit_lookup local d local l=1/255 local u=1/(16^4)local
c=1/(16^2)local m=2^8 local function f(w,y,p,v)local b=((w*u)%m)*l*y local
g=((w*c)%m)*l*p local k=(w%m)*l*v b,g,k=b-(b%1),g-(g%1),k-(k%1)return
d[b][g][k]end local q=string.rep local function j(x)local z=x.term local
E,T=z.blit,z.setCursorPos local A=x.term_height local O=x.canvas local
I,N={},{}local S,H={},{}local R,D=x.x_offset,x.y_offset local
L,U=x.width,x.height local C=q("\131",L)local M=q("\143",L)local
F=d.r_upper_bound local W=d.g_upper_bound local Y=d.b_upper_bound local P=0 for
V=1,U,3 do P=P+2 local B=O[V]local G=O[V+1]local K=O[V+2]local Q=1 for J=1,L do
local X=K[J]or G[J]local Z=f(B[J],F,W,Y)local et=f(G[J],F,W,Y)local
tt=f(X,F,W,Y)I[Q]=r[Z]N[Q]=r[et]S[Q]=r[et]H[Q]=r[tt or et]Q=Q+1 end
T(1+R,D+P-1)E(M,h(I,""),h(N,""))if P<=A then T(1+R,D+P)E(C,h(S,""),h(H,""))end
end end local function at(ot)local it=e.term or term local
nt,st,ht=it.getPaletteColor(ot)nt=nt*255 st=st*255 ht=ht*255 return
nt*(16^4)+st*(16^2)+ht end local function rt()local
dt=s.from_term()d=n.make_colorspace(dt,i.rgbrnd_defaultres or
10,nil,nil,i.rgbrnd_defaultcspace)end local function lt(ut)d=ut end
return{render=j,rgbrnd={set_lookup_space=lt,internal={current_lookup_space=d,hex_to_screen=f,setup_default_colorspace=rt,get_box_color_hex=at}}},{verified_load=function()if
not e.__bixelbox_lite then
a.module_error(t,"Can only be used with bixelbox_lite",4,i.supress)end if not
e.modules["PB_MODULE:rgbquant"]then
a.module_error(t,"Missing dependency PB_MODULE:rgbquant",4,i.supress)end if not
e.modules["PB_MODULE:palutil"]and not i.rgbrnd_nodefault then
a.module_error(t,"Missing dependency PB_MODULE:palutil",4,i.supress)end local
ct=e.background
a.restore(e,at(ct),false)n=e.modules["PB_MODULE:rgbquant"].__fn.rgbquant if
e.modules["PB_MODULE:palutil"]then
s=e.modules["PB_MODULE:palutil"].__fn.palutil end if s and not
i.rgbrnd_nodefault then rt()end
end}end,id="BB_MODULE:rgbrnd",name="BB_RGBRender",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}