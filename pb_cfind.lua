return{init=function(e,t,a,o,i,n)local function s(h,r,d,l,u,c,m)local
f,l,w=h(r,d,l)local y,m,p=h(u,c,m)return(y-f)^2+(m-l)^2+(p-w)^2 end local
function v(b,g,k,q,j,x,z)return s(b,g,k,q,j,x,z)^0.5 end local function
E(T,A)return T.distance<A.distance end local function O(I,N,S,H,R)local
D,R,L=I(S,H,R)local U={}for C=1,#N do local M=N[C]local
F,W,M=I(M[1],M[2],M[3])local Y=(D-F)^2 local P=(R-W)^2 local V=(L-M)^2
U[C]={distance=Y+P+V,index=C}end table.sort(U,E)return U[1].index,U end local
function B(G,K,Q,J,X)local Z,X,et=G(Q,J,X)local tt=math.huge local at for
ot=1,#K do local it=K[ot]local nt,st,it=G(it[1],it[2],it[3])local ht=(Z-nt)^2
local rt=(X-st)^2 local dt=(et-it)^2 local lt=ht+rt+dt if lt<=tt then tt=lt
at=ot end end return at end
return{cfind={raw_distance=s,distance=v,sort_by_distance=O,find_closest=B,internal={SMALL_TO_LARGE=E}}},{}end,id="PB_MODULE:cfind",name="PB_ColorFind",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}