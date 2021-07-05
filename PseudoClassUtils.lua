require("scot.massie.lua.lib.InternalGlobalTable")
require("scot.massie.lua.lib.StringUtils")
require("scot.massie.lua.lib.TableUtils")

---@shape Pseudoclass<T>
---@field __className string
---@field __fieldNames string[]
---@field __instanceMetatable table
---@field __constructor fun(...): T

__internal.pseudoclasses = {}

__internal.pseudoclasses.internPools = {}

__internal.pseudoclasses.classMetatable =
{
    __call = function(source, ...)
        local internPool = __internal.pseudoclasses.internPools[source]

        if internPool ~= nil then
            local internedVersion
            = tbl.getWhereKeyEquals(internPool,
                    {...},
                    --[[---@type fun(t: any[], o: any[]): boolean]] tbl.arrayContentsEqual)

            if internedVersion ~= nil then
                return internedVersion
            end
        end

        local result = source.__constructor(...)
        setmetatable(result, source.__instanceMetatable)

        if internPool ~= nil then
            internPool[{...}] = result
        end

        return result
    end,
}

---@param classTable table
---@return table
function __internal.pseudoclasses.newInstanceMetatable(classTable)
    local pseudoclass = --[[---@type Pseudoclass<any>]] classTable

    return
    {
        __index = function(t, k)
            local result = classTable[k]

            if result ~= nil then
                return result
            end

            for _, fieldName in pairs(pseudoclass.__fieldNames) do
                if fieldName == k then
                    return rawget(t, k)
                end
            end

            error("No such member: " .. tostring(k))
        end,

        __newindex = function(t, k, v)
            if pseudoclass.__fieldNames ~= nil then
                for _, fieldName in pairs(pseudoclass.__fieldNames) do
                    if fieldName == k then
                        rawset(t, k, v)
                        return
                    end
                end
            end

            error("Cannot set values directly on instance of " .. pseudoclass.__className .. ".")
        end,

        __tostring = function(o)
            local toStringFunc = classTable.toString

            if toStringFunc ~= nil then
                return toStringFunc(o)
            else
                return "(instance of " .. pseudoclass.__className .. ")"
            end
        end,

        __len = function(o)
            local sizeFunc = classTable.size

            if sizeFunc ~= nil then
                return sizeFunc(o)
            else
                error("Instances of " .. pseudoclass.__className .. " don't have a size.")
            end
        end
    }
end

---@generic T
---@param name string
---@param pseudoclass table
---@param constructor fun(...): T
---@overload fun<T>(name: string, pseudoclass: table, constructor: fun(...): T)
function makePseudoClass(name, pseudoclass, constructor)
    pseudoclass.__className = name
    pseudoclass.__constructor = constructor
    pseudoclass.__instanceMetatable = __internal.pseudoclasses.newInstanceMetatable(pseudoclass)

    if pseudoclass.__parent ~= nil then
        tbl.addAll(pseudoclass.__fieldNames, pseudoclass.__parent.__fieldNames)

        ---@param k string
        for k, v in pairs(pseudoclass.__parent) do
            if (type(k) == "string") and (not k:startsWith("__")) then
                -- Don't need to check for presence of new functions as they're added after makePseudoClass is called.
                pseudoclass[k] = v
            end
        end
    end

    setmetatable(pseudoclass, __internal.pseudoclasses.classMetatable)
end

---@param pseudoclass table
function makePseudoClassInternInstances(pseudoclass)
    __internal.pseudoclasses.internPools[pseudoclass] = {}
end

function isInstanceOfPseudoclass(itemToCheck, t)
    if getmetatable(t) ~= __internal.pseudoclasses.classMetatable then
        error("isOfType needs to be passed a pseudoclass.")
    end

    if type(itemToCheck) ~= "table" then
        return false
    end

    if getmetatable(itemToCheck) == t.__instanceMetatable then
        return true
    end

    if t.__parent ~= nil then
        return isInstanceOfPseudoclass(itemToCheck, t.__parent)
    end

    return false
end




return "LuaBundle bug workaround. Without this line, required scripts run multiple times."

