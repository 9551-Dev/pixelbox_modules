return {init=function(box,module,api,share,api_init,load_flags)
    local table_concat = table.concat
    local pb_to_blit   = api.internal.to_blit_lookup

    local string_rep = string.rep
    local function bixel_renderer(self)
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

        local sy = 0
        for y=1,height,3 do
            sy = sy + 2
            local layer_1 = canv[y]
            local layer_2 = canv[y+1]
            local layer_3 = canv[y+2]

            local n = 1
            for x=1,width do
                local color1 = layer_1[x]
                local color2 = layer_2[x]
                local color3 = layer_3[x]

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

    local function bixel_updater()
        box.width  = math.floor(box.term_width       +0.5)
        box.height = math.floor(box.term_height*(3/2)+0.5)

        api.restore(box,box.background,true,true)
    end

    return {},{verified_load=function()
        if not box.modules["PB_MODULE:rndswp"] then
            api.module_error(module,"Missing dependency PB_MODULE:rndswp",3,load_flags.supress)
        else
            box.__rndswp__renderer["bixelbox"] = {
                drawer = bixel_renderer,
                update = bixel_updater
            }
        end
    end}
end,
    id         = "PB_RENDERER:rndswp",
    name       = "PR_BixelRenderer",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}