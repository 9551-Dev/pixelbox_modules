return{init=function(e,t,a,o,o,i)local n,s local h=table.concat local
r=a.internal.texel_character_lookup local d=a.internal.texel_foreground_lookup
local l=a.internal.texel_background_lookup local u=a.internal.to_blit_lookup
local c local m=1/255 local f=1/(16^4)local w=1/(16^2)local y=2^8 local
function p(v,b,g,k)local q=((v*f)%y)*m*b local j=((v*w)%y)*m*g local
x=(v%y)*m*k q,j,x=q-(q%1),j-(j%1),x-(x%1)return c[q][j][x]end local z={}local
E={0,0,0,0,0,0}local function T(A)local O=A.term local
I,N=O.blit,O.setCursorPos local S=A.canvas local H,R,D={},{},{}local
L,U=A.x_offset,A.y_offset local C,M=A.width,A.height local F=c.r_upper_bound
local W=c.g_upper_bound local Y=c.b_upper_bound local P=0 for V=1,M,3 do P=P+1
local B=S[V]local G=S[V+1]local K=S[V+2]local Q=0 for J=1,C,2 do local X=J+1
local
Z,et,tt,at,ot,it=p(B[J],F,W,Y),p(B[X],F,W,Y),p(G[J],F,W,Y),p(G[X],F,W,Y),p(K[J],F,W,Y),p(K[X],F,W,Y)local
nt,st,ht=" ",1,Z local rt=et==Z and tt==Z and at==Z and ot==Z and it==Z if not
rt then z[it]=5 z[ot]=4 z[at]=3 z[tt]=2 z[et]=1 z[Z]=0 local
dt=z[et]+z[tt]*3+z[at]*4+z[ot]*20+z[it]*100 local lt=d[dt]local ut=l[dt]E[1]=Z
E[2]=et E[3]=tt E[4]=at E[5]=ot E[6]=it st=E[lt]ht=E[ut]nt=r[dt]end Q=Q+1
H[Q]=nt R[Q]=u[st]D[Q]=u[ht]end N(1+L,P+U)I(h(H,""),h(R,""),h(D,""))end end
local function ct(mt)local ft=e.term or term local
wt,yt,pt=ft.getPaletteColor(mt)wt=wt*255 yt=yt*255 pt=pt*255 return
wt*(16^4)+yt*(16^2)+pt end local function vt()local
bt=s.from_term()c=n.make_colorspace(bt,i.rgbrnd_defaultres or
10,nil,nil,i.rgbrnd_defaultcspace)end local function gt(kt)c=kt end
return{render=T,rgbrnd={set_lookup_space=gt,internal={current_lookup_space=c,hex_to_screen=p,setup_default_colorspace=vt,get_box_color_hex=ct}}},{verified_load=function()if
not e.__pixelbox_lite then
a.module_error(t,"Can only be used with standard pixelbox_lite",4,i.supress)end
if not e.modules["PB_MODULE:rgbquant"]then
a.module_error(t,"Missing dependency PB_MODULE:rgbquant",4,i.supress)end if not
e.modules["PB_MODULE:palutil"]and not i.rgbrnd_nodefault then
a.module_error(t,"Missing dependency PB_MODULE:palutil",4,i.supress)end local
qt=e.background
a.restore(e,ct(qt),false)n=e.modules["PB_MODULE:rgbquant"].__fn.rgbquant if
e.modules["PB_MODULE:palutil"]then
s=e.modules["PB_MODULE:palutil"].__fn.palutil end if s and not
i.rgbrnd_nodefault then vt()end
end}end,id="PB_MODULE:rgbrnd",name="PB_RGBRender",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}