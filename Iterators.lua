require("scot.massie.lua.lib.InternalGlobalTable")

__internal.iterators = {}
__internal.iterators.stateless = {}

---@generic T
---@param tables T[][]
---@param i number
---@param tn number
---@return (number, number, T, number, T[]) | nil
function __internal.iterators.stateless.mipairs(tables, i)
    i = i + 1
    local tableIndex = i

    for c = 1, #tables do
        local ctable = tables[c]
        local ctableSize = #ctable

        if tableIndex > #ctable then
            tableIndex = tableIndex - ctableSize
        else
            return i, tableIndex, ctable[tableIndex], c, ctable
        end
    end

    return nil
end

---@generic T
---@vararg T[]
---@return (fun(tables: T[][], i: number): nil | (number, number, T, number, T[])), T[][], number
function mipairs(...)
    return __internal.iterators.stateless.mipairs, {...}, 0
end

---@generic K
---@generic V
---@vararg table<K, V>
---@return fun(): nil | (K, V, number, table<K, V>)
---@overload fun<K, V>(...: table): (fun(): nil | (K, V, number, table<K, V>))
function mpairs(...)
    local tablesToIterateOver = {...}
    local currentTableNumber = 1
    ---@type K
    local kFromPreviousIteration = nil


    return function()
        ---@type K, V
        local nextK, nextV = nil, nil

        while nextK == nil do
            nextK, nextV = next(tablesToIterateOver[currentTableNumber], kFromPreviousIteration)

            if nextK == nil then
                if currentTableNumber == #tablesToIterateOver then
                    return nil
                end

                currentTableNumber = currentTableNumber + 1
                kFromPreviousIteration = nil
            else
                kFromPreviousIteration = nextK
                return nextK, nextV, currentTableNumber, tablesToIterateOver[currentTableNumber]
            end
        end
    end
end



return "LuaBundle bug workaround. Without this line, required scripts run multiple times."
