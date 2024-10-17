return {init=function(box,_,_,_,_,load_flags)
    local math_abs = math.abs

    local autorender = false

    local function std_math_round(n)
        local shifted = n + 0.5
        return shifted - shifted%1
    end

    local function draw_line_internal(x1,y1,x2,y2,color)
        local canvas = box.canvas

        if math_abs(y2-y1) < math_abs(x2-x1) then
            if x1 > x2 then
                x1,y1,x2,y2 = x2,y2,x1,y1
            end
            local delta_x = x2 - x1
            local delta_y = y2 - y1
            local y_increment = 1

            if delta_y < 0 then
                y_increment,delta_y = -1,-delta_y
            end

            local delta_error = 2*delta_y-delta_x
            local y = y1
            if y_increment < 0 then
                y = y2
                for x=x2,x1,-1 do
                    canvas[std_math_round(y)][std_math_round(x)] = color
                    if delta_error > 0 then
                        y = y + 1
                        delta_error = delta_error + 2*(delta_y-delta_x)
                    else
                        delta_error = delta_error + 2*delta_y
                    end
                end
            else
                for x=x1,x2 do
                    canvas[std_math_round(y)][std_math_round(x)] = color
                    if delta_error > 0 then
                        y = y + 1
                        delta_error = delta_error + 2*(delta_y-delta_x)
                    else
                        delta_error = delta_error + 2*delta_y
                    end
                end
            end
        else
            if y1 > y2 then
                x1,y1,x2,y2 = x2,y2,x1,y1
            end
            local delta_x = x2 - x1
            local delta_y = y2 - y1
            local x_increment = 1

            if delta_x < 0 then
                x_increment,delta_x = -1,-delta_x
            end

            local delta_error = 2*delta_x-delta_y
            local x = x1
            for y=y1,y2 do
                canvas[std_math_round(y)][std_math_round(x)] = color
                if delta_error > 0 then
                    x = x+x_increment
                    delta_error = delta_error + 2*(delta_x-delta_y)
                else
                    delta_error = delta_error + 2*delta_x
                end
            end
        end

        if autorender then box:render() end
    end

    local function extern_draw_pixel(x,y,color)
        x,y = std_math_round(x),std_math_round(y)

        box.canvas[y][x] = color

        if autorender then box:render() end
    end

    local function extern_draw_line(x1,y1,x2,y2,color)
        local canvas = box.canvas

        x1 = std_math_round(x1)
        x2 = std_math_round(x2)
        y1 = std_math_round(y1)
        y2 = std_math_round(y2)

        if y1 == y2 then
            local scanline = canvas[y1]

            if x1 > x2 then x1,x2 = x2,x1 end
            for x=x1,x2 do
                scanline[x] = color
            end

            return
        elseif x1 == x2 then
            if y1 > y2 then y1,y2 = y2,y1 end
            for y=y1,y2 do
                canvas[y][x1] = color
            end
        else
            draw_line_internal(x1,y1,x2,y2,color)
        end

        if autorender then box:render() end
    end

    local function extern_draw_box(x,y,width,height,color)
        local canvas = box.canvas

        x = std_math_round(x)
        y = std_math_round(y)

        width  = std_math_round(width)
        height = std_math_round(height)

        for y=y+1,y+height-2 do
            local scanline = canvas[y]

            scanline[x]         = color
            scanline[x+width-1] = color
        end

        local top_scanline    = canvas[y]
        local bottom_scanline = canvas[y+height-1]
        for x=x,x+width-1 do
            top_scanline   [x] = color
            bottom_scanline[x] = color
        end

        if autorender then box:render() end
    end

    local function extern_draw_filled_box(x,y,width,height,color)
        local canvas = box.canvas

        x = std_math_round(x)
        y = std_math_round(y)

        width  = std_math_round(width)
        height = std_math_round(height)

        for y=y,y+height-1 do
            local scanline = canvas[y]
            for x=x,x+width-1 do
                scanline[x] = color
            end
        end

        if autorender then box:render() end
    end

    local function extern_draw_image(image,x,y)
        local canvas = box.canvas

        x = std_math_round(x)
        y = std_math_round(y)

        for scan_index=1,#image do
            local image_scanline  = image[scan_index]
            local canvas_scanline = canvas[scan_index+y-1]

            for pixel_index=1,#image_scanline do
                local pixel_color = image_scanline[pixel_index]

                canvas_scanline[pixel_index+x-1] = pixel_color
            end
        end

        if autorender then box:render() end
    end

    local function set_autotrender(state)
        autorender = not not state
    end

    return {painp={
        loadImage  = paintutils.loadImage,
        parseImage = paintutils.parseImage,

        load_image  = paintutils.loadImage,
        parse_image = paintutils.parseImage,

        drawLine      = extern_draw_line,
        drawPixel     = extern_draw_pixel,
        drawBox       = extern_draw_box,
        drawImage     = extern_draw_image,
        drawFilledBox = extern_draw_filled_box,

        draw_line       = extern_draw_line,
        draw_pixel      = extern_draw_pixel,
        draw_box        = extern_draw_box,
        draw_image      = extern_draw_image,
        draw_filled_box = extern_draw_filled_box,

        autorender = set_autotrender,

        internal = {
            std_math_round = std_math_round,
            draw_line      = draw_line_internal
        }
    }},{verified_load=function()
        if load_flags.painpixels_autorender then
            autorender = true
        end
    end}
end,
    id         = "PB_MODULE:painpixels",
    name       = "PB_PainPixels",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}