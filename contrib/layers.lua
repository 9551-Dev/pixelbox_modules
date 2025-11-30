if not table.pack then table.pack=function(...)return{n=select("#",...),...}end
end if not table.unpack then table.unpack=unpack end local e=load if
_VERSION:find("5.1")then e=function(t,a,o,i)local n,s=loadstring(t,a)if not n
then return n,s end if i then setfenv(n,i)end return n end end local
h,r,d,l=select,table.unpack,table.pack,error local u={}local
c,m,f,w,y,p,v,b,g,k,q,j,x,z,E,T,A,O,I,N,S,H,R,D,L,U,C,M,F,W,Y,P,V,B,G,K,Q,J,X,Z,et,tt,at,ot,it,nt,st
c=function(ht,rt)return ht==rt end m=function(dt,lt)return dt~=lt end
f=function(ut,ct)return ut<ct end w=function(mt,ft)return mt<=ft end
y=function(wt,yt)return wt>yt end p=function(pt,vt)return pt>=vt end
v=function(bt,...)local gt=bt+...for kt=2,h('#',...)do gt=gt+h(kt,...)end
return gt end b=function(qt,...)local jt=qt-...for xt=2,h('#',...)do
jt=jt-h(xt,...)end return jt end g=function(zt,...)local Et=zt%...for
Tt=2,h('#',...)do Et=Et%h(Tt,...)end return Et end k=function(At,...)local
Ot=h('#',...)local It=h(Ot,...)for Nt=Ot-1,1,-1 do It=h(Nt,...)..It end return
At..It end q=function(St)return#St end j=function(Ht,Rt)return Ht[Rt]end
x=function(Dt,Lt,Ut)Dt[Lt]=Ut end z=error E=getmetatable T=next A=setmetatable
O=tostring I=type N=string.format S=table.concat H=table.unpack
R=function(Ct)if I(Ct)=="table"then return Ct["n"]else return#Ct end end
D=function(...)local Mt=d(...)Mt.tag="list"return Mt end L=function(Ft)if
I(Ft)=="table"then local Wt=Ft["tag"]if Wt=="number"then return
Ft["value"]elseif Wt=="string"then return Ft["value"]else return Ft end else
return Ft end end U=function(Yt)local Pt=Yt["parent"]if Pt then return
H(Pt,Yt["offset"]+1,Yt["n"]+Yt["offset"])else return H(Yt,1,Yt["n"])end end
C=function(Vt,...)local Bt=h("#",...)-1 local Gt,Kt if Bt>0 then
Gt={tag="list",n=Bt,r(d(...),1,Bt)}Kt=select(Bt+1,...)else
Gt={tag="list",n=0}Kt=...end return Vt(U((function()local
Qt,Jt,Xt=0,{tag="list"}Xt=Gt for Zt=1,Xt.n do Jt[0+Zt+Qt]=Xt[Zt]end Qt=Qt+Xt.n
Xt=Kt for ea=1,Xt.n do Jt[0+ea+Qt]=Xt[ea]end Qt=Qt+Xt.n Jt.n=Qt+0 return Jt
end)()))end M=function(ta)local aa=I(ta)if aa=="table"then return
ta["tag"]or"table"else return aa end end F=function(oa,ia)local
na={tag="list",n=0}local sa=R(ia)local ha=1 while ha<=sa do
na[ha]=oa(ia[ha])ha=ha+1 end na["n"]=R(ia)return na end
W=function(ra,da,la)local ua=R(da)local ca=ua-1 local ma=1 while ma<=ca do
local fa=da[ma]local wa=ra[fa]if not wa then wa={}ra[fa]=wa end ra=wa ma=ma+1
end ra[da[ua]]=la return nil end Y=function(ya,pa)return not P(ya,pa)end local
va={lookup={},tag="multimethod"}P=A(va,{__call=function(ba,ga,ka)if ga==ka then
return true else local qa=(va["lookup"][M(ga)]or{})[M(ka)]or va["default"]if
not qa then
z("No matching method to call for ("..S(D("eq?",M(ga),M(ka))," ")..")")end
return qa(ga,ka)end
end,name="eq?",args=D("x","y")})W(P,D("lookup","list","list"),function(ja,xa)if
R(ja)~=R(xa)then return false else local za=true local Ea=R(ja)local Ta=1 while
Ta<=Ea do if Y(ja[Ta],xa[Ta])then za=false end Ta=Ta+1 end return za end
end)W(P,D("lookup","table","table"),function(Aa,Oa)local Ia=true local
Na,Sa=T(Aa)while Na~=nil do if Y(Sa,Oa[Na])then Ia=false end Na,Sa=T(Aa,Na)end
return Ia end)W(P,D("lookup","symbol","symbol"),function(Ha,Ra)return
Ha["contents"]==Ra["contents"]end)W(P,D("lookup","string","symbol"),function(Da,La)return
Da==La["contents"]end)W(P,D("lookup","symbol","string"),function(Ua,Ca)return
Ua["contents"]==Ca end)W(P,D("lookup","key","string"),function(Ma,Fa)return
Ma["value"]==Fa end)W(P,D("lookup","string","key"),function(Wa,Ya)return
Wa==Ya["value"]end)W(P,D("lookup","key","key"),function(Pa,Va)return
Pa["value"]==Va["value"]end)W(P,D("lookup","number","number"),function(Ba,Ga)return
L(Ba)==L(Ga)end)W(P,D("lookup","string","string"),function(Ka,Qa)return
L(Ka)==L(Qa)end)P["default"]=function(Ja,Xa)return false end local
va={lookup={},tag="multimethod"}V=A(va,{__call=function(Za,eo)local
to=va["lookup"][M(eo)]or va["default"]if not to then
z("No matching method to call for ("..S(D("pretty",M(eo))," ")..")")end return
to(eo)end,name="pretty",args=D("x")})W(V,D("lookup","list"),function(ao)return"("..S(F(V,ao)," ")..")"end)W(V,D("lookup","symbol"),function(oo)return
oo["contents"]end)W(V,D("lookup","key"),function(io)return":"..io["value"]end)W(V,D("lookup","number"),function(no)return
N("%g",L(no))end)W(V,D("lookup","string"),function(so)return
N("%q",L(so))end)W(V,D("lookup","table"),function(ho)local
ro={tag="list",n=0}local lo,uo=T(ho)while lo~=nil do local
co,mo,fo=0,{tag="list"}mo[1+co]=V(lo).." "..V(uo)fo=ro for wo=1,fo.n do
mo[1+wo+co]=fo[wo]end co=co+fo.n mo.n=co+1 ro=mo lo,uo=T(ho,lo)end
return"{"..(S(ro," ").."}")end)W(V,D("lookup","multimethod"),function(yo)return"«method: ("..E(yo)["name"].." "..S(E(yo)["args"]," ")..")»"end)V["default"]=function(po)if
I(po)=="table"then return V["lookup"]["table"](po)else return O(po)end end
B=function(vo)if vo["message"]then return
N("demand not met: %s (%s).\n%s",vo["condition"],vo["message"],vo["traceback"])else
return N("demand not met: %s.\n%s",vo["condition"],vo["traceback"])end end
W(V,D("lookup","demand-failure"),function(bo)return B(bo)end)G=math.min local
go={__index=function(ko,qo)return
ko["parent"][qo+ko["offset"]]end,__newindex=function(jo,xo,zo)jo["parent"][xo+jo["offset"]]=zo
return nil end}K=function(Eo,To)if R(Eo)<=To then return{tag="list",n=0}elseif
Eo["parent"]and Eo["offset"]then return
A({parent=Eo["parent"],offset=Eo["offset"]+To,n=R(Eo)-To,tag=M(Eo)},go)else
return A({parent=Eo,offset=To,n=R(Eo)-To,tag=M(Eo)},go)end end
Q=function(Ao,...)local Oo=d(...)Oo.tag="list"local Io local
No={tag="list",n=0}local So=R(Oo)local Ho=1 while Ho<=So do if
not(M((J(Oo,Ho)))=="list")then
z("that's no list! "..V(J(Oo,Ho)).." (it's a "..M(J(Oo,Ho)).."!)")end
Z(No,R(J(Oo,Ho)))Ho=Ho+1 end Io=No local No={tag="list",n=0}local
So=C(G,Io)local Ho=1 while Ho<=So do Z(No,C(Ao,X(Oo,Ho)))Ho=Ho+1 end return No
end J=function(Ro,Do)if Do>=0 then return Ro[Do]else return Ro[Ro["n"]+1+Do]end
end X=function(Lo,Uo)local Co={tag="list",n=0}local Mo=R(Lo)local Fo=1 while
Fo<=Mo do Z(Co,J(J(Lo,Fo),Uo))Fo=Fo+1 end return Co end Z=function(Wo,...)local
Yo=d(...)Yo.tag="list"local Po=R(Wo)Wo["n"]=(Po+R(Yo))local Vo=R(Yo)local Bo=1
while Bo<=Vo do Wo[Po+Bo]=Yo[Bo]Bo=Bo+1 end return Wo end et=function(...)local
Go=d(...)Go.tag="list"local Ko local Qo={}if R(Go)%2==1 then
z("Expected an even number of arguments to range",2)end local Jo=R(Go)local
Xo=1 while Xo<=Jo do Qo[Go[Xo]]=Go[Xo+1]Xo=Xo+2 end Ko=Qo local
Zo,ei=Ko["from"]or 1,1+Ko["to"]or z("Expected end index, got nothing")local
ti=(Ko["by"]or 1+Zo)-Zo local ai if Zo>=ei then ai=y else ai=f end local
oi,Qo=Zo,{tag="list",n=0}while ai(oi,ei)do Z(Qo,oi)oi=oi+ti end return Qo end
tt=function(ii,...)local ni=d(...)ni.tag="list"local si,hi=ni,ii while
not(nil==hi or nil==si[1])do si,hi=K(si,1),hi[si[1]]end return hi end
at=function(ri,di)local li=R(di)local ui=li while true do if ui==0 then return
nil elseif ri(J(di,ui))then return ui else ui=ui-1 end end end
ot=A({tag="list",n=0},{__newindex=function(ci,mi,fi)ci["n"]=#ci return nil
end})it=function(wi)local yi=function(pi,vi)return ot[(at(function(bi)return
tt(bi,wi,vi)~=nil end,ot))][wi][vi]end return A({},{__index=yi})end
nt=function(gi)return{__index=it(gi),__newindex=function(ki,qi,ji)ot[1][gi][qi]=ji
return nil end}end st=function(xi,zi,Ei,Ti,Ai,Oi)local
Ii,Ni=xi["height"],xi["width"]local Si=et("from",1,"to",Ii)local
Hi=Q(function(Ri)return A({},nt(Ri))end,Si)Z(ot,xi["canvas"])xi["canvas"]=Hi
return{layers=ot}end
return{init=st,id="layers",name="Multilayer support",author="viwty",contact="viwty@discord or viwty@cock.li",report_msg="\n__name: complain over at __contact"}