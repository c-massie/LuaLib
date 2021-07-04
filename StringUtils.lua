--region iterators
---@param this string
---@return fun(): string
function string.eachLine(this)
    if this:sub(-1) ~= "\n" then
        this = this .. "\n"
    end

    return --[[---@type fun(): string]] this:gmatch("(.-)\n")
end

---@param this string
---@return fun(): string
function string.eachChar(this)
    return --[[---@type fun(): string]] this:gmatch(".")
end
--endregion

--region split
---@param this string
---@return string[]
function string.lines(this)
    ---@type string[]
    local result = {}

    for l in this:eachLine() do
        table.insert(result, l)
    end

    return result
end

---@param this string
---@return string[]
function string.chars(s)
    local result = {}

    for l in s:eachChar() do
        table.insert(result, l)
    end

    return result
end
--endregion

--region check if contains
---@param this string
---@param with string
---@return boolean
function string.startsWith(this, with)
    return this:sub(1, #with) == with
end

---@param this string
---@param with string
---@return boolean
function string.endsWith(this, with)
    return with == "" or this:sub(-#with) == with
end
--endregion

--region indent
---@param this string
---@param level number
---@return string
function string.indent(this, level)
    return this:indentWith("    ", level)
end

---@param this string
---@param with string
---@param level number
---@return string
function string.indentWith(this, with, level)
    if level == nil then
        level = 1
    end

    ---@type string[]
    local lines = {}

    for line in this:eachLine() do
        table.insert(lines, with:rep(level) .. line)
    end

    return table.concat(lines, "\n")
end
--endregion

--region get with content removed

---@param this string
---@return string
function string.trim(this)
    local result, _ = this:gsub("^%s*(.-)%s*$", "%1")
    return result
end

---@param this string
---@return string
function string.trimLines(this)
    ---@type string[]
    local lines = {}

    for line in this:eachLine() do
        table.insert(lines, line:trim())
    end

    return table.concat(lines, "\n")
end

---@param this string
---@return string
function string.trimBlankLines(this)
    local lines = this:lines()
    local firstNonBlankLine = -1

    for i = 1, #lines do
        if lines[i]:trim() ~= "" then
            firstNonBlankLine = i
            break
        end
    end

    if firstNonBlankLine == -1 then
        return ""
    end

    for i = #lines, 1, -1 do
        if lines[i]:trim() == "" then
            table.remove(lines)
        else
            break
        end
    end

    for i = firstNonBlankLine - 1, 1, -1 do
        table.remove(lines, i)
    end

    return table.concat(lines, "\n")
end

---@param this string
---@return string
function string.removeBlankLines(this)
    ---@type string[]
    local lines = {}

    for line in this:eachLine() do
        local lineTrimmed = line:trim()

        if lineTrimmed ~= "" then
            table.insert(lines, line)
        end
    end

    return table.concat(lines, "\n")
end
--endregion




return "LuaBundle bug workaround. Without this line, required scripts run multiple times."
