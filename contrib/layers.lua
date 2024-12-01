if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, mod1, _2e2e_1, len_23_1, getIdx1, setIdx_21_1, error1, getmetatable1, next1, setmetatable1, tostring1, type_23_1, format1, concat1, unpack1, n1, list1, constVal1, splice1, apply1, type1, map1, put_21_1, neq_3f_1, eq_3f_1, pretty1, demandFailure_2d3e_string1, min1, slicingView1, map2, nth1, nths1, push_21_1, range1, _2e3e3f_1, findIndexRev1, layers1, indexY1, makeMt1, init1
_3d_1 = function(v1, v2) return v1 == v2 end
_2f3d_1 = function(v1, v2) return v1 ~= v2 end
_3c_1 = function(v1, v2) return v1 < v2 end
_3c3d_1 = function(v1, v2) return v1 <= v2 end
_3e_1 = function(v1, v2) return v1 > v2 end
_3e3d_1 = function(v1, v2) return v1 >= v2 end
_2b_1 = function(x, ...) local t = x + ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end
_2d_1 = function(x, ...) local t = x - ... for i = 2, _select('#', ...) do t = t - _select(i, ...) end return t end
mod1 = function(x, ...) local t = x % ... for i = 2, _select('#', ...) do t = t % _select(i, ...) end return t end
_2e2e_1 = function(x, ...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return x .. t end
len_23_1 = function(v1) return #v1 end
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
error1 = error
getmetatable1 = getmetatable
next1 = next
setmetatable1 = setmetatable
tostring1 = tostring
type_23_1 = type
format1 = string.format
concat1 = table.concat
unpack1 = table.unpack
n1 = function(x)
  if type_23_1(x) == "table" then
    return x["n"]
  else
    return #x
  end
end
list1 = function(...)
  local xs = _pack(...) xs.tag = "list"
  return xs
end
constVal1 = function(val)
  if type_23_1(val) == "table" then
    local tag = val["tag"]
    if tag == "number" then
      return val["value"]
    elseif tag == "string" then
      return val["value"]
    else
      return val
    end
  else
    return val
  end
end
splice1 = function(xs)
  local parent = xs["parent"]
  if parent then
    return unpack1(parent, xs["offset"] + 1, xs["n"] + xs["offset"])
  else
    return unpack1(xs, 1, xs["n"])
  end
end
apply1 = function(f, ...)
  local _n = _select("#", ...) - 1
  local xss, xs
  if _n > 0 then
    xss = {tag="list", n=_n, _unpack(_pack(...), 1, _n)}
    xs = select(_n + 1, ...)
  else
    xss = {tag="list", n=0}
    xs = ...
  end
  return f(splice1((function()
    local _offset, _result, _temp = 0, {tag="list"}
    _temp = xss
    for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _temp = xs
    for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _result.n = _offset + 0
    return _result
  end)()
  ))
end
type1 = function(val)
  local ty = type_23_1(val)
  if ty == "table" then
    return val["tag"] or "table"
  else
    return ty
  end
end
map1 = function(f, x)
  local out = {tag="list", n=0}
  local forLimit = n1(x)
  local i = 1
  while i <= forLimit do
    out[i] = f(x[i])
    i = i + 1
  end
  out["n"] = n1(x)
  return out
end
put_21_1 = function(t, typs, l)
  local len = n1(typs)
  local forLimit = len - 1
  local i = 1
  while i <= forLimit do
    local x = typs[i]
    local y = t[x]
    if not y then
      y = {}
      t[x] = y
    end
    t = y
    i = i + 1
  end
  t[typs[len]] = l
  return nil
end
neq_3f_1 = function(x, y)
  return not eq_3f_1(x, y)
end
local this = {lookup={}, tag="multimethod"}
eq_3f_1 = setmetatable1(this, {__call=function(this1, x, y)
  if x == y then
    return true
  else
    local method = (this["lookup"][type1(x)] or {})[type1(y)] or this["default"]
    if not method then
      error1("No matching method to call for (" .. concat1(list1("eq?", type1(x), type1(y)), " ") .. ")")
    end
    return method(x, y)
  end
end, name="eq?", args=list1("x", "y")})
put_21_1(eq_3f_1, list1("lookup", "list", "list"), function(x, y)
  if n1(x) ~= n1(y) then
    return false
  else
    local equal = true
    local forLimit = n1(x)
    local i = 1
    while i <= forLimit do
      if neq_3f_1(x[i], y[i]) then
        equal = false
      end
      i = i + 1
    end
    return equal
  end
end)
put_21_1(eq_3f_1, list1("lookup", "table", "table"), function(x, y)
  local equal = true
  local temp, v = next1(x)
  while temp ~= nil do
    if neq_3f_1(v, y[temp]) then
      equal = false
    end
    temp, v = next1(x, temp)
  end
  return equal
end)
put_21_1(eq_3f_1, list1("lookup", "symbol", "symbol"), function(x, y)
  return x["contents"] == y["contents"]
end)
put_21_1(eq_3f_1, list1("lookup", "string", "symbol"), function(x, y)
  return x == y["contents"]
end)
put_21_1(eq_3f_1, list1("lookup", "symbol", "string"), function(x, y)
  return x["contents"] == y
end)
put_21_1(eq_3f_1, list1("lookup", "key", "string"), function(x, y)
  return x["value"] == y
end)
put_21_1(eq_3f_1, list1("lookup", "string", "key"), function(x, y)
  return x == y["value"]
end)
put_21_1(eq_3f_1, list1("lookup", "key", "key"), function(x, y)
  return x["value"] == y["value"]
end)
put_21_1(eq_3f_1, list1("lookup", "number", "number"), function(x, y)
  return constVal1(x) == constVal1(y)
end)
put_21_1(eq_3f_1, list1("lookup", "string", "string"), function(x, y)
  return constVal1(x) == constVal1(y)
end)
eq_3f_1["default"] = function(x, y)
  return false
end
local this = {lookup={}, tag="multimethod"}
pretty1 = setmetatable1(this, {__call=function(this1, x)
  local method = this["lookup"][type1(x)] or this["default"]
  if not method then
    error1("No matching method to call for (" .. concat1(list1("pretty", type1(x)), " ") .. ")")
  end
  return method(x)
end, name="pretty", args=list1("x")})
put_21_1(pretty1, list1("lookup", "list"), function(xs)
  return "(" .. concat1(map1(pretty1, xs), " ") .. ")"
end)
put_21_1(pretty1, list1("lookup", "symbol"), function(x)
  return x["contents"]
end)
put_21_1(pretty1, list1("lookup", "key"), function(x)
  return ":" .. x["value"]
end)
put_21_1(pretty1, list1("lookup", "number"), function(x)
  return format1("%g", constVal1(x))
end)
put_21_1(pretty1, list1("lookup", "string"), function(x)
  return format1("%q", constVal1(x))
end)
put_21_1(pretty1, list1("lookup", "table"), function(x)
  local out = {tag="list", n=0}
  local temp, v = next1(x)
  while temp ~= nil do
    local _offset, _result, _temp = 0, {tag="list"}
    _result[1 + _offset] = pretty1(temp) .. " " .. pretty1(v)
    _temp = out
    for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _result.n = _offset + 1
    out = _result
    temp, v = next1(x, temp)
  end
  return "{" .. (concat1(out, " ") .. "}")
end)
put_21_1(pretty1, list1("lookup", "multimethod"), function(x)
  return "«method: (" .. getmetatable1(x)["name"] .. " " .. concat1(getmetatable1(x)["args"], " ") .. ")»"
end)
pretty1["default"] = function(x)
  if type_23_1(x) == "table" then
    return pretty1["lookup"]["table"](x)
  else
    return tostring1(x)
  end
end
demandFailure_2d3e_string1 = function(failure)
  if failure["message"] then
    return format1("demand not met: %s (%s).\n%s", failure["condition"], failure["message"], failure["traceback"])
  else
    return format1("demand not met: %s.\n%s", failure["condition"], failure["traceback"])
  end
end
put_21_1(pretty1, list1("lookup", "demand-failure"), function(failure)
  return demandFailure_2d3e_string1(failure)
end)
min1 = math.min
local refMt = {__index=function(t, k)
  return t["parent"][k + t["offset"]]
end, __newindex=function(t, k, v)
  t["parent"][k + t["offset"]] = v
  return nil
end}
slicingView1 = function(list, offset)
  if n1(list) <= offset then
    return {tag="list", n=0}
  elseif list["parent"] and list["offset"] then
    return setmetatable1({parent=list["parent"], offset=list["offset"] + offset, n=n1(list) - offset, tag=type1(list)}, refMt)
  else
    return setmetatable1({parent=list, offset=offset, n=n1(list) - offset, tag=type1(list)}, refMt)
  end
end
map2 = function(fn, ...)
  local xss = _pack(...) xss.tag = "list"
  local ns
  local out = {tag="list", n=0}
  local forLimit = n1(xss)
  local i = 1
  while i <= forLimit do
    if not (type1((nth1(xss, i))) == "list") then
      error1("that's no list! " .. pretty1(nth1(xss, i)) .. " (it's a " .. type1(nth1(xss, i)) .. "!)")
    end
    push_21_1(out, n1(nth1(xss, i)))
    i = i + 1
  end
  ns = out
  local out = {tag="list", n=0}
  local forLimit = apply1(min1, ns)
  local i = 1
  while i <= forLimit do
    push_21_1(out, apply1(fn, nths1(xss, i)))
    i = i + 1
  end
  return out
end
nth1 = function(xs, idx)
  if idx >= 0 then
    return xs[idx]
  else
    return xs[xs["n"] + 1 + idx]
  end
end
nths1 = function(xss, idx)
  local out = {tag="list", n=0}
  local forLimit = n1(xss)
  local i = 1
  while i <= forLimit do
    push_21_1(out, nth1(nth1(xss, i), idx))
    i = i + 1
  end
  return out
end
push_21_1 = function(xs, ...)
  local vals = _pack(...) vals.tag = "list"
  local nxs = n1(xs)
  xs["n"] = (nxs + n1(vals))
  local forLimit = n1(vals)
  local i = 1
  while i <= forLimit do
    xs[nxs + i] = vals[i]
    i = i + 1
  end
  return xs
end
range1 = function(...)
  local args = _pack(...) args.tag = "list"
  local x
  local out = {}
  if n1(args) % 2 == 1 then
    error1("Expected an even number of arguments to range", 2)
  end
  local forLimit = n1(args)
  local i = 1
  while i <= forLimit do
    out[args[i]] = args[i + 1]
    i = i + 2
  end
  x = out
  local st, ed = x["from"] or 1, 1 + x["to"] or error1("Expected end index, got nothing")
  local inc = (x["by"] or 1 + st) - st
  local tst
  if st >= ed then
    tst = _3e_1
  else
    tst = _3c_1
  end
  local c, out = st, {tag="list", n=0}
  while tst(c, ed) do
    push_21_1(out, c)
    c = c + inc
  end
  return out
end
_2e3e3f_1 = function(x, ...)
  local keys = _pack(...) keys.tag = "list"
  local keys1, out = keys, x
  while not (nil == out or nil == keys1[1]) do
    keys1, out = slicingView1(keys1, 1), out[keys1[1]]
  end
  return out
end
findIndexRev1 = function(p, xs)
  local len = n1(xs)
  local i = len
  while true do
    if i == 0 then
      return nil
    elseif p(nth1(xs, i)) then
      return i
    else
      i = i - 1
    end
  end
end
layers1 = setmetatable1({tag="list", n=0}, {__newindex=function(self, idx, v)
  self["n"] = #self
  return nil
end})
indexY1 = function(y)
  local index = function(_5f_, x)
    return layers1[(findIndexRev1(function(t)
      return _2e3e3f_1(t, y, x) ~= nil
    end, layers1))][y][x]
  end
  return setmetatable1({}, {__index=index})
end
makeMt1 = function(y)
  return {__index=indexY1(y), __newindex=function(_5f_, x, val)
    layers1[1][y][x] = val
    return nil
  end}
end
init1 = function(box, module, api, share, initialized_3f_, loadFlags)
  local height, width = box["height"], box["width"]
  local lines = range1("from", 1, "to", height)
  local canvas = map2(function(y)
    return setmetatable1({}, makeMt1(y))
  end, lines)
  push_21_1(layers1, box["canvas"])
  box["canvas"] = canvas
  return {layers=layers1}
end
return {init=init1, id="layers", name="Multilayer support", author="viwty", contact="viwty@discord or viwty@cock.li", report_msg="\n__name: complain over at __contact"}
