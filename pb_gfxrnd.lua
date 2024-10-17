return{init=function(e,t,a,o,i,n)local function s(h)if h.getGraphicsMode()~=1
then if not o.set_term_mode then
a.module_error(t,"Terminal graphics mode must be \"1\"",3,n.supress)else
h.setGraphicsMode(1)end end end local function
r(d)s(e.term)d.term.drawPixels(d.x_offset+1,d.y_offset+1,d.canvas,d.width,d.height)end
local function l()local u,c=e.term.getSize(e.term.getGraphicsMode and
e.term.getGraphicsMode()or 1)e.term_width,e.term_height=u,c
e.width,e.height=u,c a.restore(e,e.background,true,true)end
return{render=r},{verified_load=function()if e.term.drawPixels==nil then
a.module_error(t,"Target terminal doesnt have GFX mode",3,n.supress)end local
m,f=e.term.getSize(1)e.term_width,e.term_height=m,f e.width,e.height=m,f if
e.modules["PB_MODULE:rndswp"]then
e.__rndswp__renderer["gfx"]={drawer=r,update=l}end
l()end}end,id="PB_MODULE:gfxrnd",name="PB_GFXRender",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}