return {init=function(box,module,api,share,api_init,load_flags)
    error("Not yet finished")

    local dep_arrutil,dep_medcut,dep_kmeans

    local bit_lib = _G.bit32 or _G.bit

    local MODE_TEXT    = 0
    local MODE_GFX_16  = 1
    local MODE_GFX_256 = 2

    local COLOR_RED = 1
    local COLOR_GRN = 2
    local COLOR_BLU = 3

    local gfx_std_palette = {}
    local gfx_mode_state  = MODE_TEXT
    local gfx_frozen      = false

    local gfx_effective_palette = {}

    local gfx_color_lut_16  = {}
    local gfx_color_lut_256 = {}

    local gfx_color_buffer

    local gfx_fps_limit       = 20
    local gfx_epoch_timeframe = (1/gfx_fps_limit)*1000
    local gfx_background_updt = false
    local gfx_last_update     = os.epoch("utc") + gfx_epoch_timeframe

    local last_palette_update = os.epoch("utc")

    local native_term = {}
    for k,v in pairs(box.term) do
        native_term[k] = v
    end

    local function flush_to_buffer(source_buffer,flush_target)
        local cursor_x,cursor_y = source_buffer.getCursorPos()
        local background_color  = source_buffer.getBackgroundColor()
        local text_color        = source_buffer.getTextColor()

        local _,source_height = source_buffer.getSize()
        for y=1,math.min(box.term_height,source_height) do
            flush_target.setCursorPos(1,y)
            flush_target.blit(source_buffer.getLine(y))
        end

        flush_target.setBackgroundColor(background_color)
        flush_target.setCursorPos      (cursor_x,cursor_y)
        flush_target.setTextColor      (text_color)

        return flush_target
    end

    local function init_dummy_buffer(check_gfxemu)
        if check_gfxemu and box.term.__pb_gfxemu then return {} end

        local width,height = box.term_width,box.term_height

        local dummy_parent = {
            isColor          = native_term.isColor,
            getPaletteColour = native_term.getPaletteColor,
        }

        local buffer_win = window.create(dummy_parent,1,1,width,height,false)

        return buffer_win
    end

    if type(load_flags.gfxemu_preload) == "function" then
        local tooling = {
            make_dummy  =init_dummy_buffer,
            flush_buffer=flush_to_buffer
        }

        load_flags.gfxemu_preload(tooling)
    end

    local has_current = native_term.current
    local text_mode_buffer = window.create(
        has_current and has_current() or native_term,
        1,1,native_term.getSize()
    )

    local text_mode_buffer_box = setmetatable({term=text_mode_buffer},{__index=box})

    local text_mode_methods = {
        "setBackgroundColour",
        "getBackgroundColour",
        "getBackgroundColor",
        "setBackgroundColor",
        "getTextColour",
        "setTextColour",
        "getTextColor",
        "setTextColor",
        "getCursorPos",
        "setCursorPos",
        "setVisible",
        "isVisible",
        "clearLine",
        "scroll",
        "write",
        "blit"
    }

    local function limitless_sleep(period_ms)
        local sleep_start = os.epoch("utc")
        while (sleep_start+period_ms) > os.epoch("utc") do
            os.queueEvent("PIXELBOX:gfxemu->schedule")
            os.pullEvent ("PIXELBOX:gfxemu->schedule")
        end
    end

    local function rgb_to_oklab(r,g,b)
        local l = (r*0.4122214708 + g*0.5363325363 + b*0.0514459929)^(1/3)
        local m = (r*0.2119034982 + g*0.6806995451 + b*0.1073969566)^(1/3)
        local s = (r*0.0883024619 + g*0.2817188376 + b*0.6299787005)^(1/3)

        return  l*0.2104542553 + m*0.7936177850 - s*0.0040720468,
                l*1.9779984951 - m*2.4285922050 + s*0.4505937099,
                l*0.0259040371 + m*0.7827717662 - s*0.8086757660
    end

    local distance_vectors = {}
    for i=1,16 do distance_vectors[i] = {} end

    local TABLE_SORT = table.sort
    local function SMALL_TO_LARGE(a,b) return a.distance < b.distance end
    local function pythagorean_quantize(palette,r,g,b)
        local cl,ca,cb = rgb_to_oklab(r,g,b)

        for i=1,#palette do
            local palette_entry = palette[i]

            local target_l,target_a,target_b = rgb_to_oklab(
                palette_entry[COLOR_RED],
                palette_entry[COLOR_GRN],
                palette_entry[COLOR_BLU]
            )

            local delta_l = target_l - cl
            local delta_a = target_a - ca
            local delta_b = target_b - cb

            local distance_vector = distance_vectors[i]

            -- ommiting sqrt
            distance_vector.distance = delta_l^2+delta_a^2+delta_b^2
            distance_vector.index    = i
        end

        TABLE_SORT(distance_vectors,SMALL_TO_LARGE)

        return distance_vectors[1].index
    end

    local function init_task_manager()
        local coro_list

        local function patched_pullevent(...)
            local event = table.pack(coroutine.yield(...))

            local dead_coroutines = {}

            for k,coro in pairs(coro_list) do
                local do_terminate = coro.terminate or (not coro.no_terminate and (event[1] == "terminate"))
                if coro.filter == nil or event[1] == coro.filter or do_terminate then
                    local ok,value

                    if coro.terminate then
                        ok,value = coroutine.resume(coro.coro,"terminate")
                    else
                        ok,value = coroutine.resume(coro.coro,table.unpack(event,1,event.n))
                    end

                    local coro_dead = coroutine.status(coro.coro) == "dead"

                    if ok                  then coro.filter = value    end
                    if not ok or coro_dead then dead_coroutines[k] = k end
                    if not ok and coro_dead then
                        printError("Coroutine died: "..value)
                    end
                end
            end

            for k,v in pairs(dead_coroutines) do coro_list[v] = nil end

            return table.unpack(event,1,event.n)
        end

        local run_fenv = getfenv(_G.rednet.run)
        if run_fenv.__redrun_coroutines then
            coro_list = run_fenv.__redrun_coroutines
        else
            coro_list = {}

            run_fenv.__redrun_coroutines = coro_list

            run_fenv.os = setmetatable({pullEventRaw=patched_pullevent},{__index=_G.os})
        end

        return coro_list
    end

    local function patch_text_mode(terminal,dummy)
        if terminal.__pb_gfxemu then return {} end

        local redirect_state = false
        local blink_state = terminal.getCursorBlink()

        local function switch_state(state)
            if redirect_state ~= state and state == true then
                blink_state = terminal.getCursorBlink()
                terminal.setCursorBlink(false)
            elseif redirect_state ~= state and state == false then
                terminal.setCursorBlink(blink_state)
            end

            redirect_state = state
        end

        for k,method in ipairs(text_mode_methods) do
            if dummy[method] and terminal[method] then
                local dummy_function = dummy[method]
                terminal[method] = function(...)
                    if redirect_state then
                        return dummy_function(...)
                    else
                        return text_mode_buffer[method](...)
                    end
                end
            end
        end

        return {switch=switch_state}
    end

    local text_mode_dummy      = init_dummy_buffer(true)
    local text_mode_controller = patch_text_mode(box.term,text_mode_dummy)

    local function base_n_rshift(base,n,shift)
        return math.floor(n/(base^shift))
    end

    local function hex_to_rgb(hex)
        local r_255 = bit_lib.band(0xFF,base_n_rshift(16,hex,4))
        local g_255 = bit_lib.band(0xFF,base_n_rshift(16,hex,2))
        local b_255 = bit_lib.band(0xFF,base_n_rshift(16,hex,0))

        return r_255/255,g_255/255,b_255/255
    end

    local function normalize_mode_id(mode)
        if mode == false or mode == MODE_TEXT then
            return MODE_TEXT
        elseif mode == true or mode == MODE_GFX_16 then
            return MODE_GFX_16
        elseif mode == MODE_GFX_256 then
            return MODE_GFX_256
        else
            return MODE_TEXT
        end
    end

    local log_2_color = {}
    for i=0,15 do
        log_2_color[2^i] = i
    end
    local function normalize_palette_id(mode,id)
        if mode == MODE_TEXT or mode == MODE_GFX_16 then
            return log_2_color[id]
        else
            return id
        end
    end
    local function format_palette_id(std_id,to_mode)
        if to_mode == MODE_TEXT or to_mode == MODE_GFX_16 then
            return 2^std_id
        else
            return std_id
        end
    end

    local function redirect_mode(mode)
        local current_mode = gfx_mode_state
        gfx_mode_state = mode
        return current_mode
    end

    local function populate_palette(terminal)
        local previous_mode = redirect_mode(MODE_TEXT)

        for i=0,15 do
            gfx_std_palette[i] = {terminal.getPaletteColor(2^i)}
        end
        for i=16,255 do
            gfx_std_palette[i] = {0,0,0}
        end

        redirect_mode(previous_mode)
    end

    local function populate_color_buffer(palette_id,keep_existing)
        for y=1,box.height do
            local buffer_scanline = gfx_color_buffer[y]
            for x=1,box.width do
                if not (keep_existing and buffer_scanline[x]) then
                    buffer_scanline[x] = palette_id
                end
            end
        end
    end

    local function import_text_mode_buffer(source)
        if gfx_mode_state == MODE_TEXT then
            flush_to_buffer(source,text_mode_buffer)
        else
            flush_to_buffer(source,text_mode_dummy)
        end
    end

    local function update_gfx_buffer()
        if gfx_mode_state == MODE_GFX_16 or gfx_mode_state == MODE_GFX_256 then
            local color_lut = (gfx_mode_state == MODE_GFX_16) and gfx_color_lut_16 or gfx_color_lut_256

            local current_canvas = box.canvas

            for y=1,box.height do
                local canvas_scanline = current_canvas  [y]
                local pixel_scanline  = gfx_color_buffer[y]

                for x=1,box.width do
                    canvas_scanline[x] = color_lut[pixel_scanline[x]]
                end
            end
        end
    end

    local function present_box_buffer()
        if gfx_mode_state ~= MODE_TEXT and not gfx_frozen then
            gfx_background_updt = true

            local current_epoch = os.epoch("utc")
            if current_epoch >= gfx_last_update+gfx_epoch_timeframe then
                gfx_last_update     = current_epoch
                gfx_background_updt = false

                update_gfx_buffer()
                box.render(text_mode_buffer_box)
            end
        end
    end

    local function update_gfx_mode_state()
        if gfx_mode_state == MODE_TEXT then
            flush_to_buffer(text_mode_dummy,text_mode_buffer)
            text_mode_controller.switch(false)
        else
            flush_to_buffer(text_mode_buffer,text_mode_dummy)
            text_mode_controller.switch(true)
        end
    end

    local function apply_effective_palette(terminal)
        for i=0,15 do
            terminal.setPaletteColor(2^i,
                table.unpack(gfx_effective_palette[i+1])
            )
        end
    end

    local function update_gfx_palette()
        if gfx_mode_state == MODE_TEXT or gfx_mode_state == MODE_GFX_16 then
            for i=0,15 do
                gfx_effective_palette[i+1] = gfx_std_palette[i]
            end

            for i=0,255 do
                local palette_entry = gfx_std_palette[i]

                gfx_color_lut_16[i] = 2^(pythagorean_quantize(
                    gfx_effective_palette,
                    palette_entry[COLOR_RED],
                    palette_entry[COLOR_GRN],
                    palette_entry[COLOR_BLU]
                )-1)
            end
        else
            local median_palette = dep_medcut.from_color_list(gfx_std_palette,4)

            for i=1,#median_palette do
                gfx_effective_palette[i] = median_palette[i]
            end

            for i=0,255 do
                local palette_entry = gfx_std_palette[i]

                gfx_color_lut_256[i] = 2^(pythagorean_quantize(
                    gfx_effective_palette,
                    palette_entry[COLOR_RED],
                    palette_entry[COLOR_GRN],
                    palette_entry[COLOR_BLU]
                )-1)
            end
        end

        apply_effective_palette(text_mode_buffer)
    end

    if not box.term.__pb_gfxemu then
        -- gfx functions
        function box.term.setGraphicsMode(mode)
            local new_mode_state = normalize_mode_id(mode)

            if gfx_mode_state ~= new_mode_state then
                gfx_mode_state = new_mode_state

                update_gfx_mode_state()
                update_gfx_palette   ()
                update_gfx_buffer    ()

                if gfx_mode_state ~= MODE_TEXT then
                    present_box_buffer()
                end
            end
        end
        function box.term.getGraphicsMode()
            if gfx_mode_state == MODE_TEXT then
                return false
            else
                return gfx_mode_state
            end
        end

        function box.term.getFrozen()
            return gfx_frozen
        end
        function box.term.setFrozen(state)
            if gfx_frozen == true and not gfx_frozen then
                present_box_buffer()
            end

            gfx_frozen = not not state
        end

        function box.term.setPixel(x,y,color)
            gfx_color_buffer[y+1][x+1] = normalize_palette_id(gfx_mode_state,color)

            present_box_buffer()
        end

        local function draw_pixels_fill(x,y,width,height,color)
            local final_x = x+width -1
            for current_y=y,y+height-1 do
                local scanline = gfx_color_buffer[current_y+1]
                for current_x=x,final_x do
                    scanline[current_x+1] = color
                end
            end
        end

        function box.term.drawPixels(x,y,pixels_color,width,height)
            local pixel_type = type(pixels_color)
            if pixel_type == "number" then
                local standard_color = normalize_palette_id(gfx_mode_state,pixels_color)
                draw_pixels_fill(x,y,width,height,standard_color)
            end

            present_box_buffer()
        end
        function box.term.getPixel(x,y)
            local color = gfx_color_buffer[y+1][x+1]
            return format_palette_id(color,gfx_mode_state)
        end
        function box.term.getPixels(x,y,width,height)
            local area_result = {}
            local scanline_index = 0

            local final_x = x+width-1
            for current_y=y,y+height-1 do
                local scanline = {}
                scanline_index = scanline_index + 1

                area_result[scanline_index] = scanline

                local pixel_index = 0
                for current_x=x,final_x do
                    pixel_index = pixel_index + 1

                    local color = gfx_color_buffer[current_y+1][current_x+1]
                    scanline[pixel_index] = format_palette_id(color,gfx_mode_state)
                end
            end

            return area_result
        end
        function box.term.screenshot()
            api.module_error(module,"Not yet implemented",3,load_flags.supress)
        end
        function box.term.relativeMouse()
            api.module_error(module,"Not yet implemented",3,load_flags.supress)
        end
        function box.term.showMouse()
            api.module_error(module,"Not yet implemented",3,load_flags.supress)
        end

        -- base terminal patches
        function box.term.setPaletteColor(palette_id,r_hex,g,b)
            local normalized_id = normalize_palette_id(gfx_mode_state,palette_id)

            local gfx_palette_entry = gfx_std_palette[normalized_id]

            if not gfx_palette_entry then
                api.module_error(module,"Invalid palette color",2,load_flags.supress)
            end

            if not g or not b then
                r_hex,g,b = hex_to_rgb(r_hex)
            end

            gfx_palette_entry[COLOR_RED] = r_hex
            gfx_palette_entry[COLOR_GRN] = g
            gfx_palette_entry[COLOR_BLU] = b

            last_palette_update = os.epoch("utc")
        end
        function box.term.getPaletteColor(palette_id)
            local normalized_id = normalize_palette_id(gfx_mode_state,palette_id)

            local gfx_palette_entry = gfx_std_palette[normalized_id]

            if not gfx_palette_entry then
                api.module_error(module,"Invalid palette color",2,load_flags.supress)
            end

            return  gfx_palette_entry[COLOR_RED],
                    gfx_palette_entry[COLOR_GRN],
                    gfx_palette_entry[COLOR_BLU]
        end
        function box.term.clear()
            if gfx_mode_state == MODE_TEXT then
                text_mode_buffer.clear()
            else
                populate_color_buffer(math.log(box.background,2))
            end
        end
        function box.term.getSize(mode)
            local width,height = text_mode_buffer.getSize()
            if mode then
                local mode = normalize_mode_id(mode)

                if mode == MODE_GFX_16 or mode == MODE_GFX_256 then
                    return width*2,height*3
                end
            end

            return width,height
        end
    end

    return {gfxemu = {
        import_text_buffer=import_text_mode_buffer
    }},{verified_load=function()
        if not box.modules["PB_MODULE:medcut"] then
            api.module_error(module,"Missing dependency PB_MODULE:medcut",3,load_flags.supress)
        end
        if not box.modules["PB_MODULE:arrutil"] then
            api.module_error(module,"Missing dependency PB_MODULE:arrutil",3,load_flags.supress)
        end

        dep_medcut  = box.modules["PB_MODULE:medcut"] .__fn.medcut
        dep_arrutil = box.modules["PB_MODULE:arrutil"].__fn.arrutil
        --dep_kmeans   = box.modules["PB_module:kmeans"].__fn.kmeans

        gfx_color_buffer = dep_arrutil.create_multilayer_list(1)

        populate_color_buffer(math.log(box.background,2))
        populate_palette     (native_term)
        update_gfx_palette   ()

        local task_manager = init_task_manager()

        local native_width,native_height = native_term.getSize()

        if not box.term.__pb_gfxemu then
            task_manager[("PIXELBOX:gfxrnd->%s"):format(box.term)] = {coro=coroutine.create(function()
                while true do
                    if gfx_background_updt and not gfx_frozen then
                        gfx_background_updt = false

                        update_gfx_buffer()
                        box.render(text_mode_buffer_box)
                    end

                    if last_palette_update then
                        if os.epoch("utc") > (last_palette_update+gfx_epoch_timeframe) and not gfx_frozen then
                            update_gfx_palette()
                            present_box_buffer()

                            ---@diagnostic disable-next-line: cast-local-type
                            last_palette_update = false
                        end
                    end

                    local new_width,new_height = native_term.getSize()
                    if new_width ~= native_width or new_height ~= native_height then
                        native_width  = new_width
                        native_height = new_height

                        box:resize(new_width,new_height)

                        populate_color_buffer(math.log(box.background,2),true)

                        text_mode_buffer.reposition(1,1,new_width,new_height)
                        text_mode_dummy .reposition(1,1,new_width,new_height)

                        if gfx_mode_state ~= MODE_TEXT and not gfx_frozen then
                            update_gfx_buffer()
                            box.render(text_mode_buffer_box)
                        end
                    end

                    if gfx_epoch_timeframe < 1/0.050 then
                        limitless_sleep(gfx_epoch_timeframe)
                    else
                        sleep(gfx_epoch_timeframe/1000)
                    end
                end
            end),no_terminate=true}
        end

        box.term.__pb_gfxemu = true
    end}
end,
    id         = "PB_MODULE:gfxemu",
    name       = "PB_GFXEmulator",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}