return {init=function(box,module,api,_,_,load_flags)
    local dep_rgbquant,dep_palutil

    local table_concat = table.concat
    local pb_to_blit   = api.internal.to_blit_lookup

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

    local string_rep = string.rep
    local function patched_bb_render(self)
        local term = self.term
        local blit_line,set_cursor = term.blit,term.setCursorPos

        local term_height = self.term_height

        local canv = self.canvas

        local fg_line_1,bg_line_1 = {},{}
        local fg_line_2,bg_line_2 = {},{}

        local x_offset,y_offset = self.x_offset,self.y_offset
        local width,height      = self.width,   self.height

        local even_char_line = string_rep("\131",width)
        local odd_char_line  = string_rep("\143",width)

        local red_upper_bound = rgbquant_colorspace.r_upper_bound
        local grn_upper_bound = rgbquant_colorspace.g_upper_bound
        local blu_upper_bound = rgbquant_colorspace.b_upper_bound

        local sy = 0
        for y=1,height,3 do
            sy = sy + 2
            local layer_1 = canv[y]
            local layer_2 = canv[y+1]
            local layer_3 = canv[y+2]

            local n = 1
            for x=1,width do
                local opt_color = layer_3[x] or layer_2[x]
                local color1 = hex_to_screen(layer_1[x],red_upper_bound,grn_upper_bound,blu_upper_bound)
                local color2 = hex_to_screen(layer_2[x],red_upper_bound,grn_upper_bound,blu_upper_bound)
                local color3 = hex_to_screen(opt_color, red_upper_bound,grn_upper_bound,blu_upper_bound)

                fg_line_1  [n] = pb_to_blit[color1]
                bg_line_1  [n] = pb_to_blit[color2]
                fg_line_2  [n] = pb_to_blit[color2]
                bg_line_2  [n] = pb_to_blit[color3 or color2]

                n = n + 1
            end

            set_cursor(1+x_offset,y_offset+sy-1)
            blit_line(odd_char_line,
            table_concat(fg_line_1,""),
                table_concat(bg_line_1,"")
            )

            if sy <= term_height then
                set_cursor(1+x_offset,y_offset+sy)
                blit_line(even_char_line,
                table_concat(fg_line_2,""),
                    table_concat(bg_line_2,"")
                )
            end
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
        render = patched_bb_render,

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
        if not box.__bixelbox_lite then
            api.module_error(module,"Can only be used with bixelbox_lite",4,load_flags.supress)
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
    id         = "BB_MODULE:rgbrnd",
    name       = "BB_RGBRender",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}