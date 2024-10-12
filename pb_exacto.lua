return {init=function(box,module,api,share,api_init,load_flags)
    local function exacto_resize(width,height)
        box:resize(width,height)
    end

    local function exacto_reposition(x,y)
        box.x_offset = x - 1
        box.y_offset = y - 1
    end

    local function exacto_set_plane(start_x,start_y,end_x,end_y)
        if start_x > end_x then end_x,start_x = start_x,end_x end
        if start_y > end_y then end_y,start_y = start_y,end_y end

        exacto_reposition(start_x,start_y)
        box:resize(
            end_x-start_x,
            end_y-start_y
        )
    end

    local function exacto_move(x,y,width,height)
        box.x_offset = x and (x-1) or box.x_offset
        box.y_offset = y and (y-1) or box.y_offset
        box:resize(
            width  or box.term_width,
            height or box.term_height
        )
    end

    return {exacto={
        resize     = exacto_resize,
        reposition = exacto_reposition,
        set_plane  = exacto_set_plane,
        move       = exacto_move
    }},{}
end,
    id         = "PB_MODULE:exacto",
    name       = "PB_ExactoKnife",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}