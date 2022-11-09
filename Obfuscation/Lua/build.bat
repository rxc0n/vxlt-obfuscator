@echo off
ECHO Building Vertile ...
RMDIR /s /q build
MKDIR build
glue.exe ./srlua.exe vertile-main.lua build/vertile.exe
robocopy ./src ./build/lua /E>nul

robocopy . ./build lua51.dll>nul

ECHO Done!