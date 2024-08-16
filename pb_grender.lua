return {init=function(box,module,api,_,_,supress)
    local function check_graphics_mode()
        if term.getGraphicsMode() ~= 1 then
            api.module_error(module,"Terminal graphics mode must be \"1\"",3,supress)
        end
    end

    return {
        render=function(self)
            check_graphics_mode()
            self.term.drawPixels(1,1,self.canvas)
        end
    },{
        verified_load=function()
            if box.term.drawPixels == nil then
                api.module_error(module,"Target terminal doesnt have GFX mode",3,supress)
            end

            local w,h = box.term.getSize(2)

            box.term_width,box.term_height = w,h
            box.width,     box.height      = w,h

            api.restore(box,box.background,true)
        end
    }
end,
    id         = "PB_MODULE:grender",
    name       = "PB_GraphicsRender",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}