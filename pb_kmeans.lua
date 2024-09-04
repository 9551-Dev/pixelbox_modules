return {init=function(box,module,api,share,api_init,load_flags)
    local function SMALL_TO_LARGE(a,b) return a.distance < b.distance end
    local function find_closest_centroid(r,g,b,centroids,count,colorspace)
        local target_r,target_g,target_b = r,g,b
        if colorspace then
            target_r,target_g,target_b = colorspace(r,g,b)
        end

        local closest_distance = math.huge
        local closest_index    = nil

        for centroid=1,count do
            local centroid_source = centroids[centroid]
            local centroid_a = centroid_source[1]
            local centroid_b = centroid_source[2]
            local centroid_c = centroid_source[3]

            if colorspace then
                centroid_a,centroid_b,centroid_c = colorspace(
                    centroid_a,centroid_b,centroid_c
                )
            end

            local delta_a = target_r - centroid_a
            local delta_b = target_g - centroid_b
            local delta_c = target_b - centroid_c

            -- ommiting sqrt
            local centroid_distance = delta_a^2+delta_b^2+delta_c^2
            if centroid_distance <= closest_distance then
                closest_distance = centroid_distance
                closest_index    = centroid
            end
        end

        return closest_index
    end

    local function kmeans_cluster(data_points,centroids,iterations,colorspace)
        local color_sectors  = {}
        local centroid_count = #centroids

        local distance_vectors = {}
        for centroid_id=1,centroid_count do
            color_sectors   [centroid_id] = {
                sum_red = 0,
                sum_grn = 0,
                sum_blu = 0,
                c_count = 0
            }
        end

        for iteration=1,iterations do
            for pixel_index=1,#data_points do
                local pixel = data_points[pixel_index]

                local near_centroid = find_closest_centroid(
                    pixel[1],pixel[2],pixel[3],
                    centroids,centroid_count,
                    colorspace
                )

                local bucket = color_sectors[near_centroid]
                bucket.sum_red = bucket.sum_red + pixel[1]
                bucket.sum_grn = bucket.sum_grn + pixel[2]
                bucket.sum_blu = bucket.sum_blu + pixel[3]
                bucket.c_count = bucket.c_count + 1
            end

            for bucket_id=1,centroid_count do
                local bucket = color_sectors[bucket_id]
                local color_count = bucket.c_count

                local average_r = bucket.sum_red / color_count
                local average_g = bucket.sum_grn / color_count
                local average_b = bucket.sum_blu / color_count

                bucket.sum_red = 0
                bucket.sum_grn = 0
                bucket.sum_blu = 0
                bucket.c_count = 0

                local centroid = centroids[bucket_id]
                centroid[1] = average_r
                centroid[2] = average_g
                centroid[3] = average_b
            end
        end

        return centroids
    end

    return {kmeans = {
        cluster  = kmeans_cluster,
        internal = {
            find_closest_centroid = find_closest_centroid,
            SMALL_TO_LARGE        = SMALL_TO_LARGE
        }
    }},{}
end,
    id         = "PB_MODULE:kmeans",
    name       = "PB_KMeansCluster",
    author     = "9551",
    contact    = "https://devvie.cc/contact",
    report_msg = "\n__name: module error, report issues at\n-> __contact"
}