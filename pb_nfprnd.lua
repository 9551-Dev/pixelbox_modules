return{init=function(e,t,t,t,t,t)local a={}for o=0,15 do
a[("%x"):format(o)]=2^o end local function i(n)local s={}for h
in(n.."\n"):gmatch("(.-)\n")do local r=#h local d={width=r}s[#s+1]=d for l=1,r
do local u=h:sub(l,l)d[l]=a[u]end end return s end local function c(m)local
f=fs.open(m,"rb")if f then local w=f.readAll()f.close()return i(w)end end local
function y(p,v,b,g,k)local q=e.canvas for j=1,math.min(#b,k or math.huge)do
local x=b[j]local z=q[v+j-1]for E=1,math.min(x.width,g or math.huge)do local
T=x[E]if T then z[p+E-1]=x[E]end end end end
return{nfprnd={blit_at=y,load={string=i,file=c},internal={blit_to_palette=a}}},{}end,id="PB_MODULE:nfprnd",name="PB_NFPRender",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}