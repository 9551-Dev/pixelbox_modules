return{init=function(e,t,a,o,i,n)local
s={drawer=e.render,update=function()e:resize(e.term_width,e.term_height)end}local
h={}local function r(d)if not h[d]then
a.module_error(t,"Non-existent renderer: "..tostring(d),3,n.supress)else
h[d].update()e.render=h[d].drawer return true end end local
l={__pixelbox_lite="pixelbox",__bixelbox_lite="bixelbox"}return{__rndswp__renderer=h,rndswp={set_renderer=r}},{verified_load=function()h["base"]=s
for u,c in pairs(l)do if e[u]then h[c]=s end end
end}end,id="PB_MODULE:rndswp",name="PB_RendererSwapper",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}