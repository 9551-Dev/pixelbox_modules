return {init=function(box,module,api,_,_,load_flags)
    local dep_rgbquant,dep_palutil

    local table_concat = table.concat

    local pb_texel_character_lookup  = api.internal.texel_character_lookup
    local pb_texel_foreground_lookup = api.internal.texel_foreground_lookup
    local pb_texel_background_lookup = api.internal.texel_background_lookup

    local pb_to_blit = api.internal.to_blit_lookup

    local rgbquant_colorspace

    local div_255  = 1/255
    local r_shift  = 1/(16^4)
    local g_shift  = 1/(16^2)
    local bit_band = 2^8
    local function hex_to_screen(hex,bound_r,bound_g,bound_b)
        local r = ((hex*r_shift)%bit_band)*div_255 * bound_r
        local g = ((hex*g_shift)%bit_band)*div_255 * bound_g
        local b = (hex%bit_band)          *div_255 * bound_b

        r,g,b = r-(r%1),g-(g%1),b-(b%1)

        return rgbquant_colorspace[r][g][b]
    end

    local color_lookup  = {}
    local texel_body    = {0,0,0,0,0,0}
    local function patched_pb_render(self)
        local t = self.term
        local blit_line,set_cursor = t.blit,t.setCursorPos

        local canv = self.canvas

        local char_line,fg_line,bg_line = {},{},{}

        local width,height = self.width,self.height

        local red_upper_bound = rgbquant_colorspace.r_upper_bound
        local grn_upper_bound = rgbquant_colorspace.g_upper_bound
        local blu_upper_bound = rgbquant_colorspace.b_upper_bound

        local sy = 0
        for y=1,height,3 do
            sy = sy + 1
            local layer_1 = canv[y]
            local layer_2 = canv[y+1]
            local layer_3 = canv[y+2]

            local n = 0
            for x=1,width,2 do
                local xp1 = x+1
                local b1,b2,b3,b4,b5,b6 =
                    layer_1[x],layer_1[xp1],
                    layer_2[x],layer_2[xp1],
                    layer_3[x],layer_3[xp1]

                b1 = hex_to_screen(b1,red_upper_bound,grn_upper_bound,blu_upper_bound)
                b2 = hex_to_screen(b2,red_upper_bound,grn_upper_bound,blu_upper_bound)
                b3 = hex_to_screen(b3,red_upper_bound,grn_upper_bound,blu_upper_bound)
                b4 = hex_to_screen(b4,red_upper_bound,grn_upper_bound,blu_upper_bound)
                b5 = hex_to_screen(b5,red_upper_bound,grn_upper_bound,blu_upper_bound)
                b6 = hex_to_screen(b6,red_upper_bound,grn_upper_bound,blu_upper_bound)

                local char,fg,bg = " ",1,b1

                local single_color = b2 == b1
                                and  b3 == b1
                                and  b4 == b1
                                and  b5 == b1
                                and  b6 == b1

                if not single_color then
                    color_lookup[b6] = 5
                    color_lookup[b5] = 4
                    color_lookup[b4] = 3
                    color_lookup[b3] = 2
                    color_lookup[b2] = 1
                    color_lookup[b1] = 0

                    local pattern_identifier =
                        color_lookup[b2]       +
                        color_lookup[b3] * 3   +
                        color_lookup[b4] * 4   +
                        color_lookup[b5] * 20  +
                        color_lookup[b6] * 100

                    local fg_location = pb_texel_foreground_lookup[pattern_identifier]
                    local bg_location = pb_texel_background_lookup[pattern_identifier]

                    texel_body[1] = b1
                    texel_body[2] = b2
                    texel_body[3] = b3
                    texel_body[4] = b4
                    texel_body[5] = b5
                    texel_body[6] = b6

                    fg = texel_body[fg_location]
                    bg = texel_body[bg_location]

                    char = pb_texel_character_lookup[pattern_identifier]
                end

                n = n + 1
                char_line[n] = char
                fg_line  [n] = pb_to_blit[fg]
                bg_line  [n] = pb_to_blit[bg]
            end

            set_cursor(1,sy)
            blit_line(
                table_concat(char_line,""),
                table_concat(fg_line,  ""),
                table_concat(bg_line,  "")
            )
        end
    end

    local function get_box_color_hex(color)
        local terminal = box.term or term

        local r,g,b = terminal.getPaletteColor(color)

        r = r * 255
        g = g * 255
        b = b * 255

        return r*(16^4) + g*(16^2) + b
    end

    local function setup_default_colorspace()
        local terminal_palette = dep_palutil.from_term()

        rgbquant_colorspace = dep_rgbquant.make_colorspace(
            terminal_palette,
            load_flags.rgbrnd_defaultres or 10,
            nil,nil,
            load_flags.rgbrnd_defaultcspace
        )
    end

    local function set_lookup_space(rgbquant_space)
        rgbquant_colorspace = rgbquant_space
    end

    return {
        render = patched_pb_render,

        rgbrnd = {
            set_lookup_space = set_lookup_space,
            internal = {
                current_lookup_space     = rgbquant_colorspace,
                hex_to_screen            = hex_to_screen,
                setup_default_colorspace = setup_default_colorspace,
                get_box_color_hex        = get_box_color_hex
            }
        }
    },{verified_load=function()
        if not box.__pixelbox_lite then
            api.module_error(module,"Can only be used with standard pixelbox_lite",4,load_flags.supress)
        end

        if not box.modules["PB_MODULE:rgbquant"] then
            api.module_error(module,"Missing dependency PB_MODULE:rgbquant",4,load_flags.supress)
        end
        if not box.modules["PB_MODULE:palutil"] and not load_flags.rgbrnd_nodefault then
            api.module_error(module,"Missing dependency PB_MODULE:palutil",4,load_flags.supress)
        end

        local background = box.background
        api.restore(box,get_box_color_hex(background),false)

        dep_rgbquant = box.modules["PB_MODULE:rgbquant"].__fn.rgbquant
        if box.modules["PB_MODULE:palutil"] then
            dep_palutil = box.modules["PB_MODULE:palutil"].__fn.palutil
        end

        if dep_palutil and not load_flags.rgbrnd_nodefault then
            setup_default_colorspace()
        end
    end}
end,
    id         = "PB_MODULE:rgbrnd",
    name       = "PB_RGBRender",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}