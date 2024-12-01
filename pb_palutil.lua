return{init=function(e,t,t,t,t,t)local function a(o,i)i=i or e.term for n,s in
pairs(o)do i.setPaletteColor(n,table.unpack(s))end end local function h(r,d)d=d
or 1 local l={}for u=0,15 do local c=2^u local
m,f,w=r(c)l[#l+1]={palette_index=c,color={r=m*d,g=f*d,b=w*d}}end return l end
local function y(p,v)p=p or e.term return h(p.getPaletteColor,v)end local
function b(g)return h(_G.term.nativePaletteColor,g)end local function k(q,j)j=j
or 1 local x={}for z,E in ipairs(q)do
x[#x+1]={palette_index=2^z,color={r=E[1]*j,g=E[2]*j,b=E[3]*j}}end return x end
local function T(A,O)O=O or 1 local I={}for N,S in pairs(A)do
I[#I+1]={palette_index=N,color={r=S[1]*O,g=S[2]*O,b=S[3]*O}}end return I end
local H=function(R)return 2^(R-1)end local D=function(L)return L end local
function U(C,M)M=M or H local F={}for W=1,#C do F[M(W)]=C[W]end return F end
return{palutil={apply_basic=a,from_term=y,from_native=b,from_list=k,from_basic=T,list_to_basic=U,idx={SECOND_POWER=H,LINEAR_RISE=D},internal={palette_from_func=h,}}},{}end,id="PB_MODULE:palutil",name="PB_PaletteUtil",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}