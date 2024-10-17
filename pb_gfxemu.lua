return{init=function(e,t,a,o,i,n)local s,h,r local d={}local l=0 local u=1
local c=2 local m=1 local f=2 local w=3 local y={}local p=l local v=false local
b={}local g={}local k={}local q local
j={["median_cut"]=true,["kmeans"]=false}local x=20 local z=true local E=20
local T=(1/E)*1000 local A=false local O=os.epoch("utc")+T local
I=os.epoch("utc")local N={}for S,H in pairs(e.term)do N[S]=H end local function
R(D,L)local U,C=D.getCursorPos()local M=D.getBackgroundColor()local
F=D.getTextColor()local W,Y=D.getSize()for P=1,math.min(e.term_height,Y)do
L.setCursorPos(1,P)L.blit(D.getLine(P))end
L.setBackgroundColor(M)L.setCursorPos(U,C)L.setTextColor(F)return L end local
function V(B)if B and e.term.__pb_gfxemu then return{}end local
G,K=e.term_width,e.term_height local
Q={isColor=N.isColor,getPaletteColour=N.getPaletteColor,}local
J=window.create(Q,1,1,G,K,false)return J end if
type(n.gfxemu_preload)=="function"then local
X={make_dummy=V,flush_buffer=R}n.gfxemu_preload(X)end local Z=N.current local
et=window.create(Z and Z()or N,1,1,N.getSize())local
tt=setmetatable({term=et},{__index=e})local
at={"setBackgroundColour","getBackgroundColour","getBackgroundColor","setBackgroundColor","getTextColour","setTextColour","getTextColor","setTextColor","getCursorPos","setCursorPos","setVisible","isVisible","clearLine","scroll","write","blit"}local
function ot(it)local nt=os.epoch("utc")while(nt+it)>os.epoch("utc")do
os.queueEvent("PIXELBOX:gfxemu->schedule")os.pullEvent("PIXELBOX:gfxemu->schedule")end
end local function st(ht,rt,dt,lt)local ut=math.huge local ct for mt=1,#ht do
local ft=ht[mt]local wt=ft[m]-rt local yt=ft[f]-dt local pt=ft[w]-lt local
vt=wt^2+yt^2+pt^2 if vt<=ut then ut=vt ct=mt end end return ct end local
function bt()local gt local function kt(...)local
qt=table.pack(coroutine.yield(...))local jt={}for xt,zt in pairs(gt)do local
Et=zt.terminate or(not zt.no_terminate and(qt[1]=="terminate"))if
zt.filter==nil or qt[1]==zt.filter or Et then local Tt,At if zt.terminate then
Tt,At=coroutine.resume(zt.coro,"terminate")else
Tt,At=coroutine.resume(zt.coro,table.unpack(qt,1,qt.n))end local
Ot=coroutine.status(zt.coro)=="dead"if Tt then zt.filter=At end if not Tt or Ot
then jt[xt]=xt end if not Tt and Ot then printError("Coroutine died: "..At)end
end end for It,Nt in pairs(jt)do gt[Nt]=nil end return
table.unpack(qt,1,qt.n)end local St=getfenv(_G.rednet.run)if
St.__redrun_coroutines then gt=St.__redrun_coroutines else
gt={}St.__redrun_coroutines=gt
St.os=setmetatable({pullEventRaw=kt},{__index=_G.os})end return gt end local
function Ht(Rt,Dt)if Rt.__pb_gfxemu then return{}end local Lt=false local
Ut=Rt.getCursorBlink()local function Ct(Mt)if Lt~=Mt and Mt==true then
Ut=Rt.getCursorBlink()Rt.setCursorBlink(false)elseif Lt~=Mt and Mt==false then
Rt.setCursorBlink(Ut)end Lt=Mt end for Ft,Wt in ipairs(at)do if Dt[Wt]and
Rt[Wt]then local Yt=Dt[Wt]Rt[Wt]=function(...)if Lt then return Yt(...)else
return et[Wt](...)end end end end return{switch=Ct}end local Pt=V(true)local
Vt=Ht(e.term,Pt)local Bt=1/255 local Gt=2^8 local Kt=1/(16^4)local
Qt=1/(16^2)local function
Jt(Xt)return((Xt*Kt)%Gt)*Bt,((Xt*Qt)%Gt)*Bt,(Xt%Gt)*Bt end local function
Zt(ea)if ea==false or ea==l then return l elseif ea==true or ea==u then return
u elseif ea==c then return c else return l end end local ta={}for aa=0,15 do
ta[2^aa]=aa end local function oa(ia,na)if ia==l or ia==u then return
ta[na]else return na end end local function sa(ha,ra)if ra==l or ra==u then
return 2^ha else return ha end end local function da(la)local ua=p p=l for
ca=0,15 do y[ca]={la.getPaletteColor(2^ca)}end for ma=16,255 do
y[ma]={0,0,0}end p=ua end local function fa(wa,ya)for pa=1,e.height do local
va=q[pa]for ba=1,e.width do if not(ya and va[ba])then va[ba]=wa end end end end
local function ga(ka)if p==l then R(ka,et)else R(ka,Pt)end end local function
qa()if p==u or p==c then local ja=(p==u)and g or k local xa=e.canvas for
za=1,e.height do local Ea=xa[za]local Ta=q[za]for Aa=1,e.width do
Ea[Aa]=ja[Ta[Aa]]end end end end local function Oa(Ia)if p~=l and(not v or
Ia)then A=true local Na=os.epoch("utc")if(Na>=O+T)or not z then O=Na A=false
qa()e.render(tt)end end end local function Sa()if p==l then
R(Pt,et)Vt.switch(false)else R(et,Pt)Vt.switch(true)end end local function
Ha(Ra)for Da=0,15 do Ra.setPaletteColor(2^Da,table.unpack(b[Da+1]))end end
local function La()if p==l or p==u then for Ua=0,15 do b[Ua+1]=y[Ua]end for
Ca=0,255 do local Ma=y[Ca]g[Ca]=2^(st(b,Ma[m],Ma[f],Ma[w])-1)end else local Fa
if j["median_cut"]and j["kmeans"]then local
Wa=h.from_color_list(y,4)Fa=r.cluster(y,Wa,x)elseif j["median_cut"]then
Fa=h.from_color_list(y,4)else Fa={}for Ya=0,15 do
Fa[Ya+1]={N.getPaletteColor(2^Ya)}end end for Pa=1,#Fa do b[Pa]=Fa[Pa]end for
Va=0,255 do local Ba=y[Va]k[Va]=2^(st(b,Ba[m],Ba[f],Ba[w])-1)end end Ha(et)end
if not e.term.__pb_gfxemu then function
e.term.setGraphicsMode(Ga)d[#d+1]={"setGraphicsMode",Ga}local Ka=Zt(Ga)if p~=Ka
then p=Ka Sa()La()qa()if p~=l then Oa()end end end function
e.term.getGraphicsMode()d[#d+1]={"getGraphicsMode",me}if p==l then return false
else return p end end function e.term.getFrozen()d[#d+1]={"getFrozen"}return v
end function e.term.setFrozen(Qa)d[#d+1]={"setFrozen",Qa}local Ja=not not Qa if
v==true and not Ja then qa()e.render(tt)end v=not not Qa end function
e.term.setPixel(Xa,Za,eo)d[#d+1]={"setPixel",Xa,Za,eo}q[Za+1][Xa+1]=oa(p,eo)Oa()end
local function to(ao,oo,io,no,so)local ho=ao+io-1 for ro=oo,oo+no-1 do local
lo=q[ro+1]for uo=ao,ho do lo[uo+1]=so end end end function
e.term.drawPixels(co,mo,fo,wo,yo)d[#d+1]={"drawPixels",co,mo,fo,wo,yo}local
po=type(fo)if po=="number"then local vo=oa(p,fo)to(co,mo,wo,yo,vo)elseif
po=="table"then local bo=yo or#fo for go=1,bo do local ko=fo[go]local
qo=type(ko)if qo=="table"then local jo=wo or#ko local xo=q[go+mo]for zo=1,jo do
local Eo=ko[zo]if Eo then xo[zo+co]=oa(p,Eo)end end elseif qo=="string"then
local To=wo or#ko local Ao=q[go+mo]for Oo=1,To do Ao[Oo+co]=ko:byte(Oo,Oo)end
end end end Oa()end function
e.term.getPixel(Io,No)d[#d+1]={"getPixel",Io,No}local So=q[No+1][Io+1]return
sa(So,p)end function
e.term.getPixels(Ho,Ro,Do,Lo)d[#d+1]={"getPixels",Ho,Ro,Do,Lo}local Uo={}local
Co=0 local Mo=Ho+Do-1 for Fo=Ro,Ro+Lo-1 do local Wo={}Co=Co+1 Uo[Co]=Wo local
Yo=0 for Po=Ho,Mo do Yo=Yo+1 local Vo=q[Fo+1][Po+1]Wo[Yo]=sa(Vo,p)end end
return Uo end function
e.term.screenshot()a.module_error(t,"Not yet implemented",3,n.supress)end
function
e.term.relativeMouse()a.module_error(t,"Not yet implemented",3,n.supress)end
function
e.term.showMouse()a.module_error(t,"Not yet implemented",3,n.supress)end
function
e.term.setPaletteColor(Bo,Go,Ko,Qo)d[#d+1]={"setPaletteColor",Bo,Go,Ko,Qo}local
Jo=oa(p,Bo)local Xo=y[Jo]if not Xo then
a.module_error(t,"Invalid palette color",2,n.supress)end if not Ko or not Qo
then Go,Ko,Qo=Jt(Go)end Xo[m]=Go Xo[f]=Ko Xo[w]=Qo if z then
I=os.epoch("utc")else La()Oa()end end function
e.term.getPaletteColor(Zo)d[#d+1]={"getPaletteColor",Zo}local ei=oa(p,Zo)local
ti=y[ei]if not ti then a.module_error(t,"Invalid palette color",2,n.supress)end
return ti[m],ti[f],ti[w]end function e.term.clear()d[#d+1]={"clear"}if p==l
then et.clear()else fa(math.log(e.background,2))end end function
e.term.getSize(ai)d[#d+1]={"getSize",ai}local oi,ii=et.getSize()if ai then
local ai=Zt(ai)if ai==u or ai==c then return e.width,e.height end end return
oi,ii end end local function ni(si)if si=="none"then j["kmeans"]=false
j["median_cut"]=false elseif si=="kmeans"and r then j["kmeans"]=true
j["median_cut"]=true elseif si=="median_cut"then j["kmeans"]=false
j["median_cut"]=true end return e.gfxemu end local function hi(ri)z=not not ri
return e.gfxemu end local function di(li)E=li T=(1/E)*1000 return e.gfxemu end
local function ui()e.term.gfxemu=e.gfxemu return e.gfxemu end
return{gfxemu={import_text_buffer=ga,set_quantize_type=ni,set_smart_update=hi,set_update_fps=di,add_reference=ui,internal={emu_calls=d,enum={MODE_TEXT=l,MODE_GFX_16=u,MODE_GFX_256=c,COLOR_RED=m,COLOR_GRN=f,COLOR_BLU=w,},data={text_mode_methods=at,log_2_color=ta},gfx={standard_palette=y,effective_palette=b,mode_256_color_lut=k,mode_16_color_lut=g,quantize_type=j,update_buffer=qa,present_box=Oa,update_mode_state=qa,apply_effective_p=Ha,update_gfx_palette=La},buffer={box_redirected=tt,text_mode_buffer=et,text_mode_dummy=Pt,text_mode_switch=Vt,},f={flush_buffer_to=R,make_dummy_buffer=V,limitless_sleep=ot,init_task_manager=bt,patch_text_mode=Ht,hex_to_rgb=Jt,normalize_mode_id=Zt,normalize_palette_id=oa,format_palette_id=sa,populate_palette=da,}}}},{verified_load=function()if
not e.modules["PB_MODULE:medcut"]then
a.module_error(t,"Missing dependency PB_MODULE:medcut",3,n.supress)end if not
e.modules["PB_MODULE:arrutil"]then
a.module_error(t,"Missing dependency PB_MODULE:arrutil",3,n.supress)end
h=e.modules["PB_MODULE:medcut"].__fn.medcut
s=e.modules["PB_MODULE:arrutil"].__fn.arrutil if
e.modules["PB_MODULE:kmeans"]then r=e.modules["PB_MODULE:kmeans"].__fn.kmeans
if not n.gfxemu_disable_kmeans then j["kmeans"]=true end end
q=s.create_multilayer_list(1)fa(math.log(e.background,2))da(N)La()local
ci=bt()local mi,fi=N.getSize()if not e.term.__pb_gfxemu then
ci[("PIXELBOX:gfxrnd->%s"):format(e.term)]={coro=coroutine.create(function()while
true do if z and A and not v then A=false qa()e.render(tt)end if z and I then
if os.epoch("utc")>(I+T)and not v then La()Oa()I=false end end local
wi,yi=N.getSize()if wi~=mi or yi~=fi then mi=wi fi=yi
e:resize(wi,yi)fa(math.log(e.background,2),true)et.reposition(1,1,wi,yi)Pt.reposition(1,1,wi,yi)if
p~=l and not v then qa()e.render(tt)end end if T<1/0.050 then ot(T)else
sleep(T/1000)end end end),no_terminate=true}end e.term.__pb_gfxemu=true
end}end,id="PB_MODULE:gfxemu",name="PB_GFXEmulator",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}