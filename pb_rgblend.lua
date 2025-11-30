return{init=function(e,e,e,e,e,e)local t=math.min local a=math.max local
function o(i,n,s,h,r,d,l,u)return i*(1-u)+r*u,n*(1-u)+d*u,s*(1-u)+l*u,h*(1-u)+u
end local function c(m,f,w,y,p,v,b,g)return
m*(1-g)+p,f*(1-g)+v,w*(1-g)+b,y*(1-g)+g end local function
k(q,j,x,z,E,T,A,O)return q+(E*O),j+(T*O),x+(A*O),z end local function
I(N,S,H,R,D,L,U,C)return N+D,S+L,H+U,R end local function
M(F,W,Y,P,V,B,G,K)return F-(V*K),W-(B*K),Y-(G*K),P end local function
Q(J,X,Z,et,tt,at,ot,it)return J-tt,X-at,Z-ot,et end local function
nt(st,ht,rt,dt,lt,ut,ct,mt)return lt*mt,ut*mt,ct*mt,dt end local function
ft(wt,yt,pt,vt,bt,gt,kt,qt)return bt,gt,kt,vt end local function
jt(xt,zt,Et,Tt,At,Ot,It,Nt)return At*xt,Ot*zt,It*Et,Nt*Tt end local function
St(Ht,Rt,Dt,Lt,Ut,Ct,Mt,Ft)return a(Ut,Ht),a(Ct,Rt),a(Mt,Dt),a(Ft,Lt)end local
function Wt(Yt,Pt,Vt,Bt,Gt,Kt,Qt,Jt)return
t(Gt,Yt),t(Kt,Pt),t(Qt,Vt),t(Jt,Bt)end local function
Xt(Zt,ea,ta,aa,oa,ia,na,sa)return
Zt*(1-oa)+(oa*sa),ea*(1-ia)+(ia*sa),ta*(1-na)+(na*sa),aa*(1-sa)+sa end local
function ha(ra,da,la,ua,ca,ma,fa,wa)return
ra*(1-ca)+ca,da*(1-ma)+ma,la*(1-fa)+fa,ua*(1-wa)+wa end
return{rgblend={alphamultiply={alpha=o,add=k,subtract=M,replace=nt,multiply=jt,lighten=St,darken=Wt,screen=Xt},premultiplied={alpha=c,add=I,subtract=Q,replace=ft,screen=ha}}},{}end,id="PB_MODULE:rgblend",name="PB_RGBBlend",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}