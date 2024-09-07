# These modules are not guaranteed to work, do not message 9551 for these.
<sup><sup>or you will be forced to crossdress</sup></sup>

## Module index
- [[**`Multlilayer`**]](#multilayer) - Support for layering multiple canvases on each other

# Modules

### [[Multilayer]](./layers.lisp)
This is a basic implementation of a layer system.

I'd prefer emails, but discord is also fine.

**Usage:** Layering things on top of each other. (duh)

**Notes:**
- _Probably_ not the fastest 
- Doesn't do sanity checking on custom layers

**Example Usage:**

    local image = paintutils.loadImage("image.nfp")
    for _, row in pairs(image) do
        for k, col in pairs(row) do
            if col == 0 then
                row[k] = nil
            end
        end
    end

    table.insert(box.layers, image)
