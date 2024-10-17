return{init=function(e,t,a,o,i,n)local function s(h,r)r=r or{}if h==0 then
return r end return setmetatable(r,{__index=function(d,l)local u=s(h-1)d[l]=u
return u end})end local function c(m,f)local
w=setmetatable({},{__index=function(y,p)local v=f[p]if v then return
rawget(m,v)else return rawget(m,p)end end})return w end local function
b(g,k,q)local j=k/(q+1)j=(j-j%1)+1 local x=(k-1)%q+1 return g[j][x]end local
function z(E,T,A,O)local I=T/(A+1)I=(I-I%1)+1 local N=(T-1)%A+1 return
E[I].pixels[N]end local function S(H,R)local
D=setmetatable({},{__index=function(L,U)local C=H[U]if C then return R(C)end
end,__len=function()return#H end})return D end local function M(F,W)local
Y=setmetatable({},{__index=function(P,V)if rawget(P,V)~=nil then return
rawget(P,V)end local B=F[V]if B then local G=W(B)rawset(P,V,G)return G end
end,__len=function()return#F end})return Y end local function K(Q,J)local
X={}for Z=1,#Q do X[Z]=J(Q[Z])end return X end local function
et(tt,at,ot,it,nt)local st=1/it local ht=1/(it-1)local rt=1/(nt-1)local
dt=setmetatable({},{__index=function(lt,ut)local ct=(ut-1)%it local
mt=(ut-1)*st mt=mt-mt%1 local ft=ct*ht local wt=mt*rt local yt=ft*(at-1)local
pt=wt*(ot-1)yt=yt-yt%1 pt=pt-pt%1 local vt=pt*at+yt+1 return
tt[vt]end,__len=function()return it*nt end})return dt end local function
bt(gt,kt,qt,jt)jt=jt or b local xt=kt*qt local
zt=setmetatable({},{__index=function(Et,Tt)return
jt(gt,Tt,kt,qt)end,__len=function()return xt end})return zt end
return{arrutil={create_multilayer_list=s,mt_key_remap=c,mt_val_remap=S,mt_val_remap_mem=M,mt_scale_remap=et,mt_remap_2d_to_1d=bt,cl_val_remap=K,map={pnglua=z,yx=b,}}},{}end,id="PB_MODULE:arrutil",name="PB_ArrayUtil",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}