return{init=function(e,e,e,e,e,e)local t=function(a,o)return a[1]>o[1]end local
i=function(n,s)return n[2]>s[2]end local h=function(r,d)return r[3]>d[3]end
local function l(u,c,m,f,w,y)local p=f-u local v=w-c local b=y-m if p>=v and
p>=b then return t elseif v>=p and v>=b then return i elseif b>=p and b>=v then
return h else return i end end local function
g(k,q)k[1]=k[1]+q[1]k[2]=k[2]+q[2]k[3]=k[3]+q[3]end local function
j(x,z)x[1]=x[1]/z x[2]=x[2]/z x[3]=x[3]/z end local E=math.huge local
T=table.sort local function A(O,I,N,S)local H=#O if S<I then local R=-E local
D=-E local L=-E local U=E local C=E local M=E for F=1,H do local W=O[F]local
Y,P,V=W[1],W[2],W[3]if Y<U then U=Y end if P<U then C=P end if V<M then M=V end
if Y>R then R=Y end if P>D then D=P end if V>L then L=V end end local
B=l(U,C,M,R,D,L)T(O,B)local G=math.floor(H/2+0.5)local K={}local Q={}for J=1,G
do K[J]=O[J]end for X=G+1,H do Q[X-G]=O[X]end A(K,I,N,S+1)A(Q,I,N,S+1)else
local Z={0,0,0}for et=1,H do local tt=O[et]g(Z,tt)end j(Z,H)N[#N+1]=Z end
return N end local function at(ot,it)it=it or 8 local nt={}local st={}local
ht=2^it-1 local rt=2^it local dt=rt^2 local lt=0 for ut=1,#ot do local
ct=ot[ut]local mt=ct[1]*ht local ft=ct[2]*ht local wt=ct[3]*ht mt=mt-mt%1
ft=ft-ft%1 wt=wt-wt%1 local yt=mt*dt+ft*rt+wt if not st[yt]then lt=lt+1
nt[lt]=ct st[yt]=true end end return nt end local function pt(vt,bt,gt)local
kt=at(vt,gt)if#kt<=2^bt then return kt else return A(kt,bt,{},0)end end
return{medcut={from_color_list=pt,internal={deduplicate_color_list=at,widest_channel_sort=l,divide_color=j,median_cut=A,add_to_color=g,SORT_BY_RED=t,SORT_BY_GRN=i,SORT_BY_BLU=h}}},{}end,id="PB_MODULE:medcut",name="PB_MedianCut",author="9551",contact="https://devvie.cc/contact",report_msg="\n__name: module error, report issues at\n-> __contact"}