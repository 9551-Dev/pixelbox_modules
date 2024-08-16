# <img src="./assets/logo.png" width="50"></img> Pixelbox modules
Hopefully soon to be growing collection of modules and tools to be loading and used with [pixelbox_lite](https://github.com/9551-Dev/pixelbox_lite)

## Module index
- [[**`pb_grender`**]](#pixelbox-graphicsrender) - CCPC GFX mode integration
- [[**`pb_analyzer`**]](#pixelbox-graphicsrender) - CCPC GFX mode integration

## How to load pixelbox modules?
Pixelbox provides two ways to load modules, those are
- On [**box creation**](#loading-on-creation)
- On [**"runtime"**](#loading-on-runtime)

#### Loading on creation
You can simply use of the third argument of `pixelbox.new`, this argument takes in a table of modules (and load settings, more info around [here](https://github.com/9551-Dev/pixelbox_lite?tab=readme-ov-file#methods-1))

This would look something like this
```lua
local box = require("pixelbox_lite").new(term.current(),nil,{
    require("pb_modules/module1"),
    require("pb_modules/module2"),
    require("pb_modules/module3"),

    force   = false,
    supress = false,
})
```

#### Loading on "runtime"
In case you want to split loading up or you want to load more modules later on, you can do so using the `load_modules` function, this function takes in just a single argument which acts identical to `pixelbox.new`s third argument, it just takes a list of plugins and `flags` and loads them in order. More info can again be found here [here](https://github.com/9551-Dev/pixelbox_lite?tab=readme-ov-file#methods-1))

Usage of this might look something like this
```lua
local box = require("pixelbox_lite").new(term.current())

box:load_modules{
    require("pb_modules/module1"),
    require("pb_modules/module2"),
    require("pb_modules/module3"),

    force   = false,
    supress = false,
}
```

#### Notes around loading modules
- Modules are loaded in the same order they are passed in
- Some modules may have dependencies and need to be loaded in a specific order
- Some modules might need to be loaded on `box` creation rather than `runtime`
- Modules can tell apart how they are being loaded and act accordingly.

# Modules
### [[PixelBox GraphicsRender]](./pb_grender.lua)
Redirects the pixelbox `:draw()` call to CraftOS PCs graphics mode

**Usecase:** Testing how programs run at higher resolutions

**Notes:**
- Requires graphics mode to be set to `1` for the `:draw()` call to be performed
- Doesnt enable graphics mode on its own, `term.setGraphicsMode` call required
- Supports monitors and any terminals with an existing `drawPixels` function

```
- id:   PB_MODULE:grender
- name: PB_GraphicsRender
```
### [[PixelBox Analyzer]](./pb_analyzer.lua)
Adds an analyze_buffer function which sanity checks buffer data

**Usecase:** Debugging potentially weird/internal errors thrown by pixelbox

**Methods:**
- `box[root]:analyze_buffer()` -> `[boolean]`
    - Reads all the data in the `canvas` which is meant to be used with the current setting, checks for canvas, scanline, pixel and color value validity, throws an error if something is invalid. **Returns true on all checks passed**

```
- id:   PB_MODULE:analyzer
- name: PB_Analyzer
```