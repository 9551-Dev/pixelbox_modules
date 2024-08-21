return {init=function(box,module,api,share,api_init,load_flags)
    local function create_multilayer_list(n,tbl)
        tbl = tbl or {}
        if n == 0 then return tbl end
        setmetatable(tbl, {__index = function(t, k)
            local new = create_multilayer_list(n-1)
            --if k == nil then error("Table index is nil",2) end
            t[k] = new
            return new
        end})
        return tbl
    end

    return {arrutil={create_multilayer_list=create_multilayer_list}},{}
end,
    id         = "PB_MODULE:arrutil",
    name       = "PB_ArrayUtil",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}