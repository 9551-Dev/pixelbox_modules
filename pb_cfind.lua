return {init=function(box,module,api,share,api_init,load_flags)
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
    local function sort_colors_by_distance(colspace,list,target_r,target_g,target_b)
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

    local function find_closest_color(colspace,list,target_r,target_g,target_b)
        local target_a,target_b,target_c = colspace(target_r,target_g,target_b)

        local closest_distance = math.huge
        local closest_color
        for i=1,#list do
            local source_c = list[i]
            local source_a,source_b,source_c = colspace(source_c[1],source_c[2],source_c[3])

            local deviation_a = (target_a-source_a)^2
            local deviation_b = (target_b-source_b)^2
            local deviation_c = (target_c-source_c)^2

            -- ommiting sqrt
            local distance = deviation_a + deviation_b + deviation_c

            if distance <= closest_distance then
                closest_distance = distance

                closest_color = i
            end
        end

        return closest_color
    end

    return {cfind = {
        raw_distance     = color_distance_colorspace_nosqrt,
        distance         = color_distance_colorspace,
        sort_by_distance = sort_colors_by_distance,
        find_closest     = find_closest_color,

        internal = {
            SMALL_TO_LARGE = SMALL_TO_LARGE
        }
    }},{}
end,
    id         = "PB_MODULE:cfind",
    name       = "PB_ColorFind",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}