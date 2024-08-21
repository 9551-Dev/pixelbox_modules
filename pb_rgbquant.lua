return {init=function(box,module,api,_,_,load_flags)
    local function SMALL_TO_LARGE(a,b)
        return a.distance < b.distance
    end

    local arr_util

    local TABLE_SORT = table.sort
    local function pythagorean_quantize(palette,r,g,b)
        local distance_vectors = palette.dist

        for i=1,#palette do
            local palette_entry = palette[i].color

            local delta_r = palette_entry.r - r
            local delta_g = palette_entry.g - g
            local delta_b = palette_entry.b - b

            local distance_vector = distance_vectors[i]

            -- ommiting sqrt
            distance_vector.distance = delta_r^2+delta_g^2+delta_b^2
            distance_vector.index    = palette[i].palette_index
        end

        TABLE_SORT(distance_vectors,SMALL_TO_LARGE)

        return distance_vectors[1].index
    end

    local function generate_lookup_space(base,r_res,g_res,b_res)
        local color_space = arr_util.create_multilayer_list(2)

        for r_position=0,r_res do
            for g_position=0,g_res do
                for b_position=0,b_res do
                    local r_normalized = r_position/r_res
                    local g_normalized = g_position/g_res
                    local b_normalized = b_position/b_res

                    color_space[r_position][g_position][b_position] = pythagorean_quantize(
                        base,r_normalized,g_normalized,b_normalized
                    )
                end
            end
        end

        color_space.r_upper_bound = r_res
        color_space.g_upper_bound = g_res
        color_space.b_upper_bound = b_res

        return color_space
    end

    local function palette_base_init(base)
        local distance_vectors = {}
        for i=1,#base do distance_vectors[i] = {} end

        base.dist = distance_vectors
    end

    local function func_palette(pal_func)
        local palette_base = {}

        for i=0,15 do
            local pal_idx = 2^i
            local pr,pg,pb = pal_func(pal_idx)
            palette_base[#palette_base+1] =  {
                palette_index = pal_idx,
                color = {
                    r=pr,g=pg,b=pb
                }
            }
        end

        palette_base_init(palette_base)

        return palette_base
    end

    local function palette_from_terminal(terminal)
        terminal = terminal or box.term
        return func_palette(terminal.getPaletteColor)
    end
    local function palette_from_native()
        return func_palette(term.nativePaletteColor)
    end
    local function palette_from_color_list(pal_colors)
        local palette_base = {}
        for k,v in pairs(pal_colors) do
            palette_base[#palette_base+1] = {
                palette_index = k,
                color = {
                    r=v[1],g=v[2],b=v[3]
                }
            }
        end

        palette_base_init(palette_base)

        return palette_base
    end

    local function palette_index_from_rgb(color_space,r,g,b)
        local r_snapped = r*color_space.r_upper_bound
        local g_snapped = g*color_space.g_upper_bound
        local b_snapped = b*color_space.b_upper_bound

        r_snapped = r_snapped - r_snapped % 1
        g_snapped = g_snapped - g_snapped % 1
        b_snapped = b_snapped - b_snapped % 1

        return color_space[r_snapped][g_snapped][b_snapped]
    end

    local function user_end_make_colorspace(palette,scale_r_res,g_res,b_res)
        if not scale_r_res then
            scale_r_res = math.sqrt(#palette)*2
        end

        if not g_res or not b_res then
            g_res = scale_r_res
            b_res = scale_r_res
        end

        return generate_lookup_space(
            palette,
            scale_r_res,
            g_res,
            b_res
        )
    end

    return {
        rgbquant={
            from_rgb       =palette_index_from_rgb,
            make_colorspace=user_end_make_colorspace,

            pal={
                from_term  =palette_from_terminal,
                from_native=palette_from_native,
                from_list  =palette_from_color_list
            },
            internal={
                SMALL_TO_LARGE       =SMALL_TO_LARGE,
                pythagorean_quantize =pythagorean_quantize,
                generate_lookup_space=generate_lookup_space,
                palette_base_init    =palette_base_init,
                func_palette         =func_palette
            }
        }
    },{verified_load=function()
        if not box.modules["PB_MODULE:arrutil"] then
            api.module_error(module,"Missing dependency PB_MODULE:arrutil",3,load_flags.supress)
        end

        arr_util = box.modules["PB_MODULE:arrutil"].__fn.arrutil
    end}
end,
    id         = "PB_MODULE:rgbquant",
    name       = "PB_RGBQuantizer",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}