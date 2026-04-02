# BufferPlus

Bit-level buffer wrapper built on top of Roblox `buffer` library.

## Features
- Bit offset based read/write
- Supports `u1`, `u2`, `u4`, `u8`, `u16`, `u32`
- Byte-aligned string read/write
- Manual offset control (bit addressing)
- Type and bounds validation
- Proxy-based object structure

## Usage

```lua
local BufferPlus = require(path.to.BufferPlus)

-- create buffer
local buf = BufferPlus.new(16)

-- write values
buf:writeu8(0, 255)
buf:writeu4(8, 10)

-- read values
local a = buf:readu8(0)
local b = buf:readu4(8)

-- strings
buf:writestring(16, "hello")
local str = buf:readstring(16, 5)
