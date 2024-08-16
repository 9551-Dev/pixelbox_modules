return {init=function(_,module,api,_,_,supress_errors)
    local function err(str)
        api.module_error(module,str,3,supress_errors)
    end

    local to_blit = {}
    for i = 0, 15 do
        to_blit[2^i] = ("%x"):format(i)
    end

    return {
        analyze_buffer = function(self)
            local canvas = self.canvas
            if not canvas then
                err("Box missing canvas. Possible to regenerate with\n\npixelbox.restore(box,box.background)")
            end

            for y=1,self.height do
                local row = canvas[y]
                if not row then
                    err(("Box is missing a pixel row: %d"):format(y))
                end

                for x=1,self.width do
                    local pixel = row[x]
                    if not pixel then
                        err(("Box is missing a pixel at:\n\nx:%d y:%d"):format(x,y))
                    elseif not to_blit[pixel] then
                        err(("Box has an invalid pixel at:\n\nx:%d y:%d. Value: %s"):format(x,y,pixel))
                    end
                end
            end

            return true
        end
    },{}
end,
    id         = "PB_MODULE:analyzer",
    name       = "PB_Analyzer",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}