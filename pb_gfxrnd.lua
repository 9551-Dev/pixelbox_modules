return {init=function(box,module,api,share,_,flags)
    local function check_graphics_mode(terminal)
        if terminal.getGraphicsMode() ~= 1 then
            if not share.set_term_mode then
                api.module_error(module,"Terminal graphics mode must be \"1\"",3,flags.supress)
            else terminal.setGraphicsMode(1) end
        end
    end

    return {
        render=function(self)
            check_graphics_mode(self.term)
            self.term.drawPixels(1,1,self.canvas)
        end
    },{
        verified_load=function()
            if box.term.drawPixels == nil then
                api.module_error(module,"Target terminal doesnt have GFX mode",3,flags.supress)
            end

            local w,h = box.term.getSize(1)

            box.term_width,box.term_height = w,h
            box.width,     box.height      = w,h

            api.restore(box,box.background,true)
        end
    }
end,
    id         = "PB_MODULE:gfxrnd",
    name       = "PB_GFXRender",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}