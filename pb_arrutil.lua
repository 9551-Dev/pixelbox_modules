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

    local function metatable_remap(tbl,mappings)
        local remapped_list = setmetatable({},{__index=function(self,key)
            local remapped_val = mappings[key]
            if remapped_val then
                return rawget(tbl,remapped_val)
            else
                return rawget(tbl,key)
            end
        end})

        return remapped_list
    end

    local function indexer_2d_remap_yx(tbl,key,width)
        local y_index = key/(width+1)
        y_index = (y_index - y_index%1) + 1

        local x_index = (key-1)%width+1

        return tbl[y_index][x_index]
    end

    local function indexer_2d_remap_pnglua(tbl,key,width,height)
        local y_index = key/(width+1)
        y_index = (y_index - y_index%1) + 1

        local x_index = (key-1)%width+1

        return tbl[y_index].pixels[x_index]
    end

    local function metatable_remap_2d_to_1d(tbl,width,height,indexer)
        indexer = indexer or indexer_2d_remap_yx

        local size = width*height
        local remapped_list = setmetatable({},{__index=function(self,key)
            return indexer(tbl,key,width,height)
        end,__len=function()
            return size
        end})

        return remapped_list
    end

    return {arrutil = {
        create_multilayer_list = create_multilayer_list,
        mt_remap               = metatable_remap,
        mt_remap_2d_to_1d      = metatable_remap_2d_to_1d,
        map = {
            pnglua = indexer_2d_remap_pnglua,
            yx     = indexer_2d_remap_yx,
        }
    }},{}
end,
    id         = "PB_MODULE:arrutil",
    name       = "PB_ArrayUtil",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}