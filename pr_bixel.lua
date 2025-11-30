return{init=function(e,t,a,o,i,n)local s=table.concat local
h=a.internal.to_blit_lookup local r=string.rep local function d(l)local
u=l.term local c,m=u.blit,u.setCursorPos local f=l.term_height local w=l.canvas
local y,p={},{}local v,b={},{}local g,k=l.x_offset,l.y_offset local
q,j=l.width,l.height local x=r("\131",q)local z=r("\143",q)local E=0 for
T=1,j,3 do E=E+2 local A=w[T]local O=w[T+1]local I=w[T+2]local N=1 for S=1,q do
local H=A[S]local R=O[S]local D=I[S]y[N]=h[H]p[N]=h[R]v[N]=h[R]b[N]=h[D or
R]N=N+1 end m(1+g,k+E-1)c(z,s(y,""),s(p,""))if E<=f then
m(1+g,k+E)c(x,s(v,""),s(b,""))end end end local function
L()e.width=math.floor(e.term_width+0.5)e.height=math.floor(e.term_height*(3/2)+0.5)a.restore(e,e.background,true,true)end
return{},{verified_load=function()if not e.modules["PB_MODULE:rndswp"]then
a.module_error(t,"Missing dependency PB_MODULE:rndswp",3,n.supress)else
e.__rndswp__renderer["bixelbox"]={drawer=d,update=L}end
end}end,id="PB_RENDERER:rndswp",name="PR_BixelRenderer",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}