# Basic structure
A module is just a table, with metadata and an `init` function.

### Metadata
- `id` - The id of the module, used for collision checking.
- `name` - The name of the module, used in the error message.
- `author` - The name of the author of the module, __not__ the contact info.
- `contact` - The contact info, used for the error message. It can be anything,
though you should prefer a link to your issue tracker.
- `report_msg` - The error message to display, you can use the module info by
prefixing it with `__`.

### Init signature
Arguments:
- `box` - The pixelbox object, returned from `:new`.
- `module` - Your module metadata, like id and name.
- `api` - The pixelbox _module_, which contains the internals.
- `share` - A table shared between all modules.
- `initialized?` - Whether or not pixelbox generated the lookups.
  -  "you could for example modify the sampling_lookup to lower the teletext char artifacting for a specific usecase (like a graph or something idk)"
  - \- devvie (i have no clue about what that shit means)
- `load-flags` - Things passed into the modules table when loading them.

Return values:
- `values` - Values inserted into the pixelbox object.
  - Note, however, that you cannot replace values that are already in the box,
  like canvas.
- `callbacks` - refer to the [callbacks](#callbacks) section.

# Callbacks

## `verified-load`
This is called when pixelbox is done initializing modules.

It takes no arguments, and is not expected to return anything.

### Written by @viw-ty
mention/email me if this is outdated/wrong
