return {init=function(box,module,api,share,api_init,load_flags)
    local arr_util

    local function get_most_channel(max,min)
        local diffs = {}
        for i=1,3 do
            diffs[i] = {val=max[i]-min[i],ind=i}
        end
        table.sort(diffs,function(a,b) return a.val > b.val end)
        return diffs[1].ind
    end

    local function add_color(c1,c2)
        return {
            c1[1] + c2[1],
            c1[2] + c2[2],
            c1[3] + c2[3],
        }
    end

    local function color_chunk(total,count)
        return {
            total[1] / count,
            total[2] / count,
            total[3] / count
        }
    end

    local MAX,MIN = math.max,math.min

    local function median_cut(tbl,splits,parts,splited)
        if splited < splits then
            local max = {
                -math.huge,
                -math.huge,
                -math.huge,
            }
            local min = {
                math.huge,
                math.huge,
                math.huge
            }

            local diffirences = arr_util.create_multilayer_list(1)
            for k,v in pairs(tbl) do
                for i=1,3 do
                    max[i] = MAX(max[i],v[i])
                    min[i] = MIN(min[i],v[i])
                    diffirences[k][i] = v[i]
                end
            end

            local mchan = get_most_channel(max,min)
            table.sort(tbl,function(a,b)
                return a[mchan] > b[mchan]
            end)

            local split = {{},{}}

            for i=1,#tbl do
                local index = math.ceil((i*2)/#tbl)
                local t = split[index]
                t[#t+1] = tbl[i]
            end

            median_cut(split[1],splits,parts,splited+1)
            median_cut(split[2],splits,parts,splited+1)
        else
            local count = 0
            local total = {0,0,0}
            for k,v in pairs(tbl) do
                total = add_color(v,total)
                count = count + 1
            end
            parts[#parts+1] = color_chunk(total,count)
        end
        return parts
    end

    local function deduplicate_color_list(color_list)
        local unique_colors = {}
        local color_lookup  = arr_util.create_multilayer_list(2)

        for k,color in ipairs(color_list) do
            local r = color[1]
            local g = color[2]
            local b = color[3]

            if not color_lookup[r][g][b] then
                unique_colors[#unique_colors+1] = color
                color_lookup[r][g][b] = true
            end
        end

        return unique_colors
    end

    local function median_cut_color_list(color_list,splits)
        local unique_color_list = deduplicate_color_list(color_list)

        if #unique_color_list <= 2^splits then
            return unique_color_list
        else
            return median_cut(unique_color_list,splits,{},0)
        end
    end

    local SECOND_POWER_INDEXER = function(n) return 2^(n-1) end
    local LINEAR_RISE_INDEXER  = function(n) return n       end

    local function to_palette_with_indexer(colors,indexer)
        indexer = indexer or SECOND_POWER_INDEXER

        local palette_base = {}
        for color_index=1,#colors do
            palette_base[indexer(color_index)] = colors[color_index]
        end

        return palette_base
    end

    local function apply_palette_term(pal_colors,terminal)
        terminal = terminal or term
        for pal_index,color in pairs(pal_colors) do
            terminal.setPaletteColor(pal_index,table.unpack(color))
        end
    end

    return {
        medcut={
            from_color_list = median_cut_color_list,
            to_palette      = to_palette_with_indexer,
            apply_palette   = apply_palette_term,
            idx = {
                SECOND_POWER = SECOND_POWER_INDEXER,
                LINEAR_RISE  = LINEAR_RISE_INDEXER
            },
            internal = {
                deduplicate_color_list = deduplicate_color_list,
                get_most_channel       = get_most_channel,
                color_chunk            = color_chunk,
                median_cut             = median_cut,
                add_color              = add_color,
            }
        }
    },{verified_load=function()
        if not box.modules["PB_MODULE:arrutil"] then
            api.module_error(module,"Missing dependency PB_MODULE:arrutil",3,load_flags.supress)
        end

        arr_util = box.modules["PB_MODULE:arrutil"].__fn.arrutil
    end}
end,
    id         = "PB_MODULE:medcut",
    name       = "PB_MedianCut",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}