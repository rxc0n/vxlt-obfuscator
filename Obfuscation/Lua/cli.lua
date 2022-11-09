-- This Script is Part of the Vertile Obfuscator by Vxlt#0246
--
-- test.lua
-- This script contains the Code for the Vertile CLI

-- Configure package.path for requiring Vertile
local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/%\\])") or "";
end
package.path = script_path() .. "?.lua;" .. package.path;
require("src.cli");