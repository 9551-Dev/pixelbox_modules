return{init=function(e,t,a,o,i,n)local function s(h,r)e:resize(h,r)end local
function d(l,u)e.x_offset=l-1 e.y_offset=u-1 end local function c(m,f,w,y)if
m>w then w,m=m,w end if f>y then y,f=f,y end d(m,f)e:resize(w-m,y-f)end local
function p(v,b,g,k)e.x_offset=v and(v-1)or e.x_offset e.y_offset=b and(b-1)or
e.y_offset e:resize(g or e.term_width,k or e.term_height)end
return{exacto={resize=s,reposition=d,set_plane=c,move=p}},{}end,id="PB_MODULE:exacto",name="PB_ExactoKnife",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}