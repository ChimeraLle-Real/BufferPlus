--[[
    BufferPlus
    -----------------------------------------------------
    Bit-level buffer wrapper using Roblox buffer library.

    Features:
        - Bit offset based read/write
        - u1 / u2 / u4 / u8 / u16 / u32 support
        - Byte-aligned string operations
        - Manual offset handling
        - Type and bounds checks
        - Proxy-based structure

    Made by ChimeraLle
    -----------------------------------------------------
]]

export type BufferPlus = {
	buffer: buffer,
	size: number,
	
	readu1: (self: BufferPlus, offset: number) -> number,
	readu2: (self: BufferPlus, offset: number) -> number,
	readu4: (self: BufferPlus, offset: number) -> number,
	readu8: (self: BufferPlus, offset: number) -> number,
	readu16: (self: BufferPlus, offset: number) -> number,
	readu32: (self: BufferPlus, offset: number) -> number,
	
	writeu1: (self: BufferPlus, offset: number, value: number) -> (),
	writeu2: (self: BufferPlus, offset: number, value: number) -> (),
	writeu4: (self: BufferPlus, offset: number, value: number) -> (),
	writeu8: (self: BufferPlus, offset: number, value: number) -> (),
	writeu16: (self: BufferPlus, offset: number, value: number) -> (),
	writeu32: (self: BufferPlus, offset: number, value: number) -> (),
	
	readstring: (self: BufferPlus, offset: number, len: number) -> string,
	writestring: (self: BufferPlus, offset: number, value: string) -> (),
}

local rbx_buffer_create = buffer.create
local rbx_buffer_readbits = buffer.readbits
local rbx_buffer_writebits = buffer.writebits
local rbx_buffer_readstring = buffer.readstring
local rbx_buffer_writestring = buffer.writestring

local rbx_table_clone = table.clone

local rbx_type = type
local rbx_error = error
local rbx_assert = assert
local rbx_newproxy = newproxy
local rbx_getmetatable = getmetatable

local BufferPlusModule = {}
local BufferPlus = {}

local function checktype(any, typ, err)
	if rbx_type(any) ~= typ then
		rbx_error(err)
	end
end

local function checknum(num, min, max, err)
	if num < min or num > max then
		rbx_error(err)
	end
end

function BufferPlusModule.new(size : number) : BufferPlus
	checktype(size, "number", "size must be a number")
	checknum(size, 0, 4096, "size out of range")
	local proxy = rbx_newproxy(true)
	local meta = rbx_getmetatable(proxy)
	meta.__metatable = nil
	local new = rbx_table_clone(BufferPlus) :: BufferPlus
	new.buffer = rbx_buffer_create(size)
	new.size = size
	meta.__index = new
	return (proxy :: any) :: BufferPlus
end

function BufferPlusModule.fromstring(str : string) : BufferPlus
	checktype(str, "string", "str must be a string")
	local new = BufferPlusModule.new(#str)
	new:writestring(0, str)
	return new
end

function BufferPlus:readu1(offset : number) : number
	checktype(offset, "number", "offset must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 1, "offset out of range")
	local buff = self.buffer
	return rbx_buffer_readbits(buff, offset, 1)
end

function BufferPlus:readu2(offset : number) : number
	checktype(offset, "number", "offset must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 2, "offset out of range")
	local buff = self.buffer
	return rbx_buffer_readbits(buff, offset, 2)
end

function BufferPlus:readu4(offset : number) : number
	checktype(offset, "number", "offset must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 4, "offset out of range")
	local buff = self.buffer
	return rbx_buffer_readbits(buff, offset, 4)
end

function BufferPlus:readu8(offset : number) : number
	checktype(offset, "number", "offset must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 8, "offset out of range")
	local buff = self.buffer
	return rbx_buffer_readbits(buff, offset, 8)
end

function BufferPlus:readu16(offset : number) : number
	checktype(offset, "number", "offset must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 16, "offset out of range")
	local buff = self.buffer
	return rbx_buffer_readbits(buff, offset, 16)
end

function BufferPlus:readu32(offset : number) : number
	checktype(offset, "number", "offset must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 32, "offset out of range")
	local buff = self.buffer
	return rbx_buffer_readbits(buff, offset, 32)
end

function BufferPlus:readstring(offset : number, len : number) : string
	checktype(offset, "number", "offset must be a number")
	checktype(len, "number", "len must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 1, "offset out of range")
	rbx_assert(offset % 8 == 0, "offset must be byte-aligned")
	local byteOffset = offset // 8
	checknum(len, 0, size - byteOffset, "len out of range")
	local buff = self.buffer
	return rbx_buffer_readstring(buff, byteOffset, len)
end

function BufferPlus:writeu1(offset : number, value : number)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "number", "value must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 1, "offset out of range")
	checknum(value, 0, 1, "value out of range")
	local buff = self.buffer
	rbx_buffer_writebits(buff, offset, 1, value)
end

function BufferPlus:writeu2(offset : number, value : number)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "number", "value must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 2, "offset out of range")
	checknum(value, 0, 3, "value out of range")
	local buff = self.buffer
	rbx_buffer_writebits(buff, offset, 2, value)
end

function BufferPlus:writeu4(offset : number, value : number)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "number", "value must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 4, "offset out of range")
	checknum(value, 0, 15, "value out of range")
	local buff = self.buffer
	rbx_buffer_writebits(buff, offset, 4, value)
end

function BufferPlus:writeu8(offset : number, value : number)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "number", "value must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 8, "offset out of range")
	checknum(value, 0, 255, "value out of range")
	local buff = self.buffer
	rbx_buffer_writebits(buff, offset, 8, value)
end

function BufferPlus:writeu16(offset : number, value : number)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "number", "value must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 16, "offset out of range")
	checknum(value, 0, 65535, "value out of range")
	local buff = self.buffer
	rbx_buffer_writebits(buff, offset, 16, value)
end

function BufferPlus:writeu32(offset : number, value : number)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "number", "value must be a number")
	local size = self.size
	checknum(offset, 0, size * 8 - 32, "offset out of range")
	checknum(value, 0, 4294967295, "value out of range")
	local buff = self.buffer
	rbx_buffer_writebits(buff, offset, 32, value)
end

function BufferPlus:writestring(offset : number, value : string)
	checktype(offset, "number", "offset must be a number")
	checktype(value, "string", "value must be a string")
	local size = self.size
	checknum(offset, 0, size * 8 - 1, "offset out of range")
	rbx_assert(offset % 8 == 0, "offset must be byte-aligned")
	local byteOffset = offset // 8
	local buff = self.buffer
	rbx_buffer_writestring(buff, byteOffset, value)
end

return BufferPlusModule
