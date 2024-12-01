return{init=function(e,t,t,t,t,a)local o=math.abs local i=false local function
n(s)local h=s+0.5 return h-h%1 end local function r(d,l,u,c,m)local f=e.canvas
if o(c-l)<o(u-d)then if d>u then d,l,u,c=u,c,d,l end local w=u-d local y=c-l
local p=1 if y<0 then p,y=-1,-y end local v=2*y-w local b=l if p<0 then b=c for
g=u,d,-1 do f[n(b)][n(g)]=m if v>0 then b=b+1 v=v+2*(y-w)else v=v+2*y end end
else for k=d,u do f[n(b)][n(k)]=m if v>0 then b=b+1 v=v+2*(y-w)else v=v+2*y end
end end else if l>c then d,l,u,c=u,c,d,l end local q=u-d local j=c-l local x=1
if q<0 then x,q=-1,-q end local z=2*q-j local E=d for T=l,c do f[n(T)][n(E)]=m
if z>0 then E=E+x z=z+2*(q-j)else z=z+2*q end end end if i then e:render()end
end local function A(O,I,N)O,I=n(O),n(I)e.canvas[I][O]=N if i then
e:render()end end local function S(H,R,D,L,U)local C=e.canvas
H=n(H)D=n(D)R=n(R)L=n(L)if R==L then local M=C[R]if H>D then H,D=D,H end for
F=H,D do M[F]=U end return elseif H==D then if R>L then R,L=L,R end for W=R,L
do C[W][H]=U end else r(H,R,D,L,U)end if i then e:render()end end local
function Y(P,V,B,G,K)local Q=e.canvas P=n(P)V=n(V)B=n(B)G=n(G)for V=V+1,V+G-2
do local J=Q[V]J[P]=K J[P+B-1]=K end local X=Q[V]local Z=Q[V+G-1]for P=P,P+B-1
do X[P]=K Z[P]=K end if i then e:render()end end local function
et(tt,at,ot,it,nt)local st=e.canvas tt=n(tt)at=n(at)ot=n(ot)it=n(it)for
at=at,at+it-1 do local ht=st[at]for tt=tt,tt+ot-1 do ht[tt]=nt end end if i
then e:render()end end local function rt(dt,lt,ut)local ct=e.canvas
lt=n(lt)ut=n(ut)for mt=1,#dt do local ft=dt[mt]local wt=ct[mt+ut-1]for yt=1,#ft
do local pt=ft[yt]wt[yt+lt-1]=pt end end if i then e:render()end end local
function vt(bt)i=not not bt end
return{painp={loadImage=paintutils.loadImage,parseImage=paintutils.parseImage,load_image=paintutils.loadImage,parse_image=paintutils.parseImage,drawLine=S,drawPixel=A,drawBox=Y,drawImage=rt,drawFilledBox=et,draw_line=S,draw_pixel=A,draw_box=Y,draw_image=rt,draw_filled_box=et,autorender=vt,internal={std_math_round=n,draw_line=r}}},{verified_load=function()if
a.painpixels_autorender then i=true end
end}end,id="PB_MODULE:painpixels",name="PB_PainPixels",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}