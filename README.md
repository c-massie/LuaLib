General utility scripts for Lua.

This directory is expected to be placed at "X/scot/massie/lua/lib", where X is a lua root directory.

Scripts are written with [Luanalysis](https://github.com/Benjamin-Dobell/IntelliJ-Luanalysis) annotations.

All scripts here may be imported with `require("scot.massie.lua.lib.LuaLib")`.

Note that as of the time of writing, [Luabundle](https://github.com/Benjamin-Dobell/luabundle) has a bug where scripts that are loaded via `require(...)` multiple times are run multiple times where there's no top-level `return` statement. This has been worked around by adding a return statement at the end of each file inteded to be loaded in this way, explaining this issue.
