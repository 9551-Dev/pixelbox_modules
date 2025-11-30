return{init=function(e,e,e,e,e,e)local t=_G.bit32 or _G.bit local a=t.lshift
local o=t.band local function i(n,s,h)return
a(n*0xFF,16)+a(s*0xFF,8)+a(h*0xFF,0)end local function r(d,l,u,c)return
a(d*0xFF,24)+a(l*0xFF,16)+a(u*0xFF,8)+a(c*0xFF,0)end local m=1/255 local
f=1/(16^4)local w=1/(16^2)local function y(p)return
o(0xFF,p*f)*m,o(0xFF,p*w)*m,o(0xFF,p)*m end local v=1/(16^6)local
b=1/(16^4)local g=1/(16^2)local function k(q)return
o(0xFF,q*v)*m,o(0xFF,q*b)*m,o(0xFF,q*g)*m,o(0xFF,q)*m end local j=1/(16^2)local
function x(z)local E=z*j E=E-E%1 return E end
return{hexutil={rgba_to_hex=r,hex_to_rgba=k,rgb_to_hex=i,hex_to_rgb=y,remove_alpha=x}},{}end,id="PB_MODULE:hexutil",name="PB_HexUtil",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}