@echo off
setlocal enabledelayedexpansion

for /f "tokens=*" %%i in ('dir /b *_ob.lua') do (
	echo "%%i"
	set name=%%~ni
    del "!name:~0,-3!%%~xi"
	ren "%%i" "!name:~0,-3!%%~xi"
)

del "locales\ruRU.lua"
ren "locales\ruRU_ob.lua" ruRU.lua
del "locales\enUS.lua"
ren "locales\enUS_ob.lua" enUS.lua

pause