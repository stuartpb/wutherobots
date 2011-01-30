# Requirements

To run wutherobots.wlua, you'll need:

- [Lua](http://lua.org)
- [IUPLua](http://www.tecgraf.puc-rio.br/iup/)
- [LuaGL](http://luagl.sourceforge.net/)

On Windows, you can get all this and more by installing [Lua for Windows](http://code.google.com/p/luaforwindows/downloads/detail?name=LuaForWindows_v5.1.4-40.exe).

Outside of Windows, check your local package manager (which will most likely have packages for Lua) and/or Sourceforge (there are some good tips out there for setting up the files you can get from Sourceforge if you search for them).

# Running
Both robots execute the procedure in proc.txt. All 5 possible commands are shown in the sample procedure (SWITCH performs a GOTO if and only if the robot is standing on the switch at the 0 position). The goal is to bring both robots to the same position, at which point the window will close. (A solution can be found in spoilers/solutionproc.txt.)
