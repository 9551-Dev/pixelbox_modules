return {init=function(box,module,api,share,api_init,load_flags)
    local base_render = {
        drawer = box.render,
        update = function()
            box:resize(
                box.term_width,
                box.term_height
            )
        end
    }

    local renderer_list = {}

    local function swap_renderer(type)
        if not renderer_list[type] then
            api.module_error(module,"Non-existent renderer: "..tostring(type),3,load_flags.supress)
        else
            renderer_list[type].update()
            box.render = renderer_list[type].drawer
            return true
        end
    end

    local base_aliases = {
        __pixelbox_lite = "pixelbox",
        __bixelbox_lite = "bixelbox"
    }

    return {
        __rndswp__renderer=renderer_list,
        rndswp={
            set_renderer = swap_renderer
        }
    },{verified_load=function()
        renderer_list["base"] = base_render

        for k,v in pairs(base_aliases) do
            if box[k] then renderer_list[v] = base_render end
        end
    end}
end,
    id         = "PB_MODULE:rndswp",
    name       = "PB_RendererSwapper",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}