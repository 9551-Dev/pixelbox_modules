return {init=function(box,_,_,_,_,_)
    local function apply_basic_palette_term(pal_colors,terminal)
        terminal = terminal or box.term
        for pal_index,color in pairs(pal_colors) do
            terminal.setPaletteColor(pal_index,table.unpack(color))
        end
    end

    local function palette_from_func(pal_func,scalar)
        scalar = scalar or 1

        local palette_base = {}
        for i=0,15 do
            local pal_idx = 2^i
            local pal_r,pal_g,pal_b = pal_func(pal_idx)

            palette_base[#palette_base+1] =  {
                palette_index = pal_idx,
                color = {r=pal_r*scalar,g=pal_g*scalar,b=pal_b*scalar}
            }
        end

        return palette_base
    end

    local function palette_from_terminal(terminal,scalar)
        terminal = terminal or box.term
        return palette_from_func(terminal.getPaletteColor,scalar)
    end
    local function palette_from_native(scalar)
        return palette_from_func(_G.term.nativePaletteColor,scalar)
    end
    local function palette_from_color_list(palette_color,scalar)
        scalar = scalar or 1

        local palette_base = {}
        for k,v in ipairs(palette_color) do
            palette_base[#palette_base+1] = {
                palette_index = 2^k,
                color = {r=v[1]*scalar,g=v[2]*scalar,b=v[3]*scalar}
            }
        end

        return palette_base
    end
    local function palette_from_basic(palette_color,scalar)
        scalar = scalar or 1

        local palette_base = {}
        for k,v in pairs(palette_color) do
            palette_base[#palette_base+1] = {
                palette_index = k,
                color = {r=v[1]*scalar,g=v[2]*scalar,b=v[3]*scalar}
            }
        end

        return palette_base
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


    return {palutil = {
        apply_basic   = apply_basic_palette_term,
        from_term     = palette_from_terminal,
        from_native   = palette_from_native,
        from_list     = palette_from_color_list,
        from_basic    = palette_from_basic,
        list_to_basic = to_palette_with_indexer,

        idx = {
            SECOND_POWER = SECOND_POWER_INDEXER,
            LINEAR_RISE  = LINEAR_RISE_INDEXER
        },
        internal = {
            palette_from_func = palette_from_func,
        }
    }},{}
end,
    id         = "PB_MODULE:palutil",
    name       = "PB_PaletteUtil",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}