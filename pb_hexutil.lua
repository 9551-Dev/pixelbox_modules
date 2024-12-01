return {init=function(_,_,_,_,_,_)
    local bit_lib = _G.bit32 or _G.bit

    local bit_lshift = bit_lib.lshift
    local bit_band   = bit_lib.band

    local function rgb_to_hex(r,g,b)
        return  bit_lshift(r*0xFF,16) +
                bit_lshift(g*0xFF,8) +
                bit_lshift(b*0xFF,0)
    end

    local function rgba_to_hex(r,g,b,a)
        return  bit_lshift(r*0xFF,24) +
                bit_lshift(g*0xFF,16) +
                bit_lshift(b*0xFF,8) +
                bit_lshift(a*0xFF,0)
    end

    local div_255  = 1/255

    local rgb_r_rshift = 1/(16^4)
    local rgb_g_rshift = 1/(16^2)
    local function hex_to_rgb(hex)
        return  bit_band(0xFF,hex*rgb_r_rshift)*div_255,
                bit_band(0xFF,hex*rgb_g_rshift)*div_255,
                bit_band(0xFF,hex)             *div_255
    end

    local rgba_r_rshift = 1/(16^6)
    local rgba_g_rshift = 1/(16^4)
    local rgba_b_rshift = 1/(16^2)
    local function hex_to_rgba(hex)
        return  bit_band(0xFF,hex*rgba_r_rshift)*div_255,
                bit_band(0xFF,hex*rgba_g_rshift)*div_255,
                bit_band(0xFF,hex*rgba_b_rshift)*div_255,
                bit_band(0xFF,hex)              *div_255
    end

    local alpha_rem_shift = 1/(16^2)
    local function remove_alpha(hex)
        local result = hex*alpha_rem_shift
        result = result - result%1

        return result
    end

    return {hexutil={
        rgba_to_hex  = rgba_to_hex,
        hex_to_rgba  = hex_to_rgba,
        rgb_to_hex   = rgb_to_hex,
        hex_to_rgb   = hex_to_rgb,
        remove_alpha = remove_alpha
    }},{}
end,
    id         = "PB_MODULE:hexutil",
    name       = "PB_HexUtil",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}