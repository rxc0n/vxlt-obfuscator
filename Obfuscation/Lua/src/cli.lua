-- This Script is Part of the Vertile Obfuscator by Vxlt#0246
--
-- test.lua
-- This script contains the Code for the Vertile CLI

-- Configure package.path for requiring Vertile
local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/%\\])")
end
package.path = script_path() .. "?.lua;" .. package.path;
---@diagnostic disable-next-line: different-requires
local Vertile = require("vertile");
Vertile.Logger.logLevel = Vertile.Logger.LogLevel.Info;

-- Override Error callback
--[[Vertile.Logger.errorCallback = function(...)
    print(Vertile.colors(Vertile.Config.NameUpper .. ": " .. ..., "red"))
	os.exit(1);
end]]

-- see if the file exists
local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end
  
-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
  end

-- CLI
local config;
local sourceFile;
local outFile;
local luaVersion;
local prettyPrint;

Vertile.colors.enabled = true;

-- Parse Arguments
local i = 1;
while i <= #arg do
    local curr = arg[i];
    if curr:sub(1, 2) == "--" then
        if curr == "--preset" or curr == "--p" then
            if config then
                Vertile.Logger:warn("The config was set multiple times");
            end

            i = i + 1;
            local preset = Vertile.Presets[arg[i]];
            if not preset then
                Vertile.Logger:error(string.format("A Preset with the name \"%s\" was not found!", tostring(arg[i])));
            end

            config = preset;
        elseif curr == "--config" or curr == "--c" then
            i = i + 1;
            local filename = tostring(arg[i]);
            if not file_exists(filename) then
                Vertile.Logger:error(string.format("The config file \"%s\" was not found!", filename));
            end

            local content = table.concat(lines_from(filename), "\n");
            -- Load Config from File
            local func = loadstring(content);
            -- Sandboxing
            setfenv(func, {});
            config = func();
        elseif curr == "--out" or curr == "--o" then
            i = i + 1;
            if(outFile) then
                Vertile.Logger:warn("The output file was specified multiple times!");
            end
            outFile = arg[i];
        elseif curr == "--nocolors" then
            Vertile.colors.enabled = false;
        elseif curr == "--Lua51" then
            luaVersion = "Lua51";
        elseif curr == "--LuaU" then
            luaVersion = "LuaU";
        elseif curr == "--pretty" then
            prettyPrint = true;
        else
            Vertile.Logger:warn(string.format("The option \"%s\" is not valid and therefore ignored", curr));
        end
    else
        if sourceFile then
            Vertile.Logger:error(string.format("Unexpected argument \"%s\"", arg[i]));
        end
        sourceFile = tostring(arg[i]);
    end
    i = i + 1;
end

if not sourceFile then
    Vertile.Logger:error("No input file was specified!")
end

if not config then
    Vertile.Logger:warn("No config was specified, falling back to Minify preset");
    config = Vertile.Presets.Minify;
end

-- Add Option to override Lua Version
config.LuaVersion = luaVersion or config.LuaVersion;
config.PrettyPrint = prettyPrint ~= nil and prettyPrint or config.PrettyPrint;

if not file_exists(sourceFile) then
    Vertile.Logger:error(string.format("The File \"%s\" was not found!", sourceFile));
end

if not outFile then
    if sourceFile:sub(-4) == ".lua" then
        outFile = sourceFile:sub(0, -5) .. ".obfuscated.lua";
    else
        outFile = sourceFile .. ".obfuscated.lua";
    end
end

local source = table.concat(lines_from(sourceFile), "\n");
local pipeline = Vertile.Pipeline:fromConfig(config);
local out = pipeline:apply(source, sourceFile);
Vertile.Logger:info(string.format("Writing output to \"%s\"", outFile));

-- Write Output
local handle = io.open(outFile, "w");
handle:write(out);
handle:close();