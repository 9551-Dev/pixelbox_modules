return {init=function(_,_,_,_,_,_)
    local MATH_MIN = math.min
    local MATH_MAX = math.max

    local function blend_alpha_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r * (1-s_a) + s_r*s_a,
                d_g * (1-s_a) + s_g*s_a,
                d_b * (1-s_a) + s_b*s_a,
                d_a * (1-s_a) + s_a
    end

    local function blend_alpha_premultiplied(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r * (1-s_a) + s_r,
                d_g * (1-s_a) + s_g,
                d_b * (1-s_a) + s_b,
                d_a * (1-s_a) + s_a
    end

    local function blend_add_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r + (s_r*s_a),
                d_g + (s_g*s_a),
                d_b + (s_b*s_a),
                d_a
    end

    local function blend_add_premultiplied(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r+s_r,
                d_g+s_g,
                d_b+s_b,
                d_a
    end

    local function blend_subtract_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r - (s_r*s_a),
                d_g - (s_g*s_a),
                d_b - (s_b*s_a),
                d_a
    end

    local function blend_subtract_premultiplied(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r-s_r,
                d_g-s_g,
                d_b-s_b,
                d_a
    end

    local function blend_replace_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  s_r*s_a,
                s_g*s_a,
                s_b*s_a,
                d_a
    end

    local function blend_replace_premultiplied(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return s_r,s_g,s_b,d_a
    end

    local function blend_multiply_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  s_r*d_r,
                s_g*d_g,
                s_b*d_b,
                s_a*d_a
    end

    local function blend_lighten_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  MATH_MAX(s_r,d_r),
                MATH_MAX(s_g,d_g),
                MATH_MAX(s_b,d_b),
                MATH_MAX(s_a,d_a)
    end

    local function blend_darken_alphamultiply(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  MATH_MIN(s_r,d_r),
                MATH_MIN(s_g,d_g),
                MATH_MIN(s_b,d_b),
                MATH_MIN(s_a,d_a)
    end

    local function blend_screen_alphamultiply(dR,dG,dB,dA,sR,sG,sB,sA)
        return  dR * (1-sR) + (sR*sA),
                dG * (1-sG) + (sG*sA),
                dB * (1-sB) + (sB*sA),
                dA * (1-sA) + sA
    end

    local function blend_screen_premultiplied(d_r,d_g,d_b,d_a,s_r,s_g,s_b,s_a)
        return  d_r * (1-s_r) + s_r,
                d_g * (1-s_g) + s_g,
                d_b * (1-s_b) + s_b,
                d_a * (1-s_a) + s_a
    end

    return {rgblend={
        alphamultiply = {
            alpha    = blend_alpha_alphamultiply,
            add      = blend_add_alphamultiply,
            subtract = blend_subtract_alphamultiply,
            replace  = blend_replace_alphamultiply,
            multiply = blend_multiply_alphamultiply,
            lighten  = blend_lighten_alphamultiply,
            darken   = blend_darken_alphamultiply,
            screen   = blend_screen_alphamultiply
        },
        premultiplied = {
            alpha    = blend_alpha_premultiplied,
            add      = blend_add_premultiplied,
            subtract = blend_subtract_premultiplied,
            replace  = blend_replace_premultiplied,
            screen   = blend_screen_premultiplied
        }
    }},{}
end,
    id         = "PB_MODULE:rgblend",
    name       = "PB_RGBBlend",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}