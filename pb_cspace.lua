return {init=function(_,_,_,_,_,_)

    local function rgb_to_oklab(r,g,b)
        local l = (r*0.4122214708 + g*0.5363325363 + b*0.0514459929)^0.3333333
        local m = (r*0.2119034982 + g*0.6806995451 + b*0.1073969566)^0.3333333
        local s = (r*0.0883024619 + g*0.2817188376 + b*0.6299787005)^0.3333333

        return  l*0.2104542553 + m*0.7936177850 - s*0.0040720468,
                l*1.9779984951 - m*2.4285922050 + s*0.4505937099,
                l*0.0259040371 + m*0.7827717662 - s*0.8086757660
    end

    local function rgb_to_xyz(r,g,b)
        if r > 0.04045 then r = ((r+0.055)/1.055)^2.4
        else r = r/12.92 end

        if g > 0.04045 then g = ((g+0.055)/1.055)^2.4
        else g = g/12.92 end

        if b > 0.04045 then b = ((b+0.055)/1.055)^2.4
        else b = b/12.92 end

        return  r*0.4124 + g*0.3576 + b*0.1805,
                r*0.2126 + g*0.7152 + b*0.0722,
                r*0.0193 + g*0.1192 + b*0.9505
    end

    local cielab_const = 16 / 116
    local function rgb_to_cielab(r,g,b)
        local x,y,z = rgb_to_xyz(r,g,b)

        local spc_x = x / 94.811
        local spc_y = y / 100
        local spc_z = z / 107.304

        if spc_x > 0.008856 then spc_x = spc_x^0.3333333
        else spc_x = 7.787*spc_x + cielab_const end

        if spc_y > 0.008856 then spc_y = spc_y^0.3333333
        else spc_y = 7.787*spc_y + cielab_const end

        if spc_z > 0.008856 then spc_z = spc_z^0.3333333
        else spc_z = 7.787*spc_z + cielab_const end

        return  (16*spc_y) - 16,
                50*(spc_x-spc_y),
                20*(spc_y-spc_z)
    end

    local function rgb_to_rgb(r,g,b)
        return r,g,b
    end

    local function color_distance_colorspace_nosqrt(colspace,source_r,source_g,source_b,target_r,target_g,target_b)
        local source_a,source_b,source_c = colspace(source_r,source_g,source_b)
        local target_a,target_b,target_c = colspace(target_r,target_g,target_b)

        return  (target_a-source_a)^2 +
                (target_b-source_b)^2 +
                (target_c-source_c)^2
    end

    local function color_distance_colorspace(colspace,source_r,source_g,source_b,target_r,target_g,target_b)
        return color_distance_colorspace_nosqrt(
            colspace,
            source_r,source_g,source_b,
            target_r,target_g,target_b
        )^0.5
    end

    local function SMALL_TO_LARGE(a,b) return a.distance < b.distance end
    local function find_closest_color(colspace,list,target_r,target_g,target_b)
        local target_a,target_b,target_c = colspace(target_r,target_g,target_b)

        local distances = {}
        for i=1,#list do
            local source_c = list[i]
            local source_a,source_b,source_c = colspace(source_c[1],source_c[2],source_c[3])

            local deviation_a = (target_a-source_a)^2
            local deviation_b = (target_b-source_b)^2
            local deviation_c = (target_c-source_c)^2

            distances[i] = {
                distance = deviation_a+deviation_b+deviation_c,
                index    = i
            }
        end

        table.sort(distances,SMALL_TO_LARGE)

        return distances[1].index,distances
    end

    local function find_furthest_color(colspace,list,target_r,target_g,target_b)
        local distances = select(2,find_closest_color(
            colspace,list,
            target_r,target_g,target_b
        ))

        return distances[#distances].index
    end

    return {cspace = {
        color_distance_colorspace_nosqrt = color_distance_colorspace_nosqrt,
        color_distance_colorspace        = color_distance_colorspace,
        find_closest_color               = find_closest_color,
        find_furthest_color              = find_furthest_color,
        space = {
            cielab = rgb_to_cielab,
            oklab  = rgb_to_oklab,
            rgb    = rgb_to_rgb,
            xyz    = rgb_to_xyz
        },
        internal = {
            SMALL_TO_LARGE = SMALL_TO_LARGE
        }
    }},{}
end,
    id         = "PB_MODULE:cspace",
    name       = "PB_ColorSpace",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}