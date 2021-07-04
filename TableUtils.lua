require("scot.massie.lua.lib.InternalGlobalTable")

-- tbl is an alias of table, which I can add my own util functions to and access without Luanalysis shouting at me.
tbl = {}
__internal.tbl = {}


--region rerouted standard table functions

---
--- Given a list where all elements are strings or numbers, returns the string
--- `list[i]..sep..list[i+1] ... sep..list[j]`. The default value for
--- `sep` is the empty string, the default for `i` is 1, and the default for
--- `j` is #list. If `i` is greater than `j`, returns the empty string.
---@overload fun(list:string[]|number[]|(string|number)[]):string
---@overload fun(list:string[]|number[]|(string|number)[], sep:string):string
---@overload fun(list:string[]|number[]|(string|number)[], sep:string, i:number):string
---@param list string[]|number[]|(string|number)[]
---@param sep string
---@param i number
---@param j number
---@return string
function tbl.concat(list, sep, i, j)
    return table.concat(list, sep, i, j)
end

---
--- Inserts element `value` at position `pos` in `list`, shifting up the
--- elements to `list[pos]`, `list[pos+1]`, `···`, `list[#list]`. The default
--- value for `pos` is ``#list+1`, so that a call `table.insert(t,x)`` inserts
--- `x` at the end of list `t`.
---@overload fun<T>(list:T[], value:T):void
---@generic T
---@param list T[]
---@param pos number
---@param value T
function tbl.insert(list, pos, value)
    return table.insert(list, pos, value)
end

---
--- Moves elements from table a1 to table `a2`, performing the equivalent to
--- the following multiple assignment: `a2[t]`,`··· = a1[f]`,`···,a1[e]`. The
--- default for `a2` is `a1`. The destination range can overlap with the source
--- range. The number of elements to be moved must fit in a Lua integer.
---
--- Returns the destination table `a2`.
---@overload fun(a1:table, f:number, e:number, t:number):table
---@param a1 table
---@param f number
---@param e number
---@param t number
---@param a2 table
---@return table
function tbl.move(a1, f, e, t, a2)
    return table.move(a1, f, e, t, a2)
end

---
--- Returns a new table with all arguments stored into keys 1, 2, etc. and
--- with a field "`n`" with the total number of arguments. Note that the
--- resulting table may not be a sequence, if some arguments are **nil**.
---@generic T
---@vararg T
---@return std__Packed<T>
function tbl.pack(...)
    return table.pack(...)
end

---
--- Removes from `list` the element at position `pos`, returning the value of
--- the removed element. When `pos` is an integer between 1 and `#list`, it
--- shifts down the elements `list[pos+1]`, `list[pos+2]`, `···`,
--- `list[#list]` and erases element `list[#list]`; The index pos can also be 0
--- when `#list` is 0, or `#list` + 1; in those cases, the function erases
--- the element `list[pos]`.
---
--- The default value for `pos` is `#list`, so that a call `table.remove(l)`
--- removes the last element of list `l`.
---@overload fun<V>(list:V[]):V
---@generic V
---@param list V[]
---@param pos number
---@return V
function tbl.remove(list, pos)
    return table.remove(list, pos)
end

---
--- Sorts list elements in a given order, *in-place*, from `list[1]` to
--- `list[#list]`. If `comp` is given, then it must be a function that receives
--- two list elements and returns true when the first element must come before
--- the second in the final order (so that, after the sort, `i < j` implies not
--- `comp(list[j],list[i]))`. If `comp` is not given, then the standard Lua
--- operator `<` is used instead.
---
--- Note that the `comp` function must define a strict partial order over the
--- elements in the list; that is, it must be asymmetric and transitive.
--- Otherwise, no valid sort may be possible.
---
--- The sort algorithm is not stable: elements considered equal by the given
--- order may have their relative positions changed by the sort.
---@overload fun<V>(list:V[]):number
---@generic V
---@param list V[]
---@param comp fun(a:V, b:V):boolean
---@return number
function tbl.sort(list, comp)
    return table.sort(list, comp)
end

---
--- Returns the elements from the given list. This function is equivalent to
--- return `list[i]`, `list[i+1]`, `···`, `list[j]`
--- By default, i is 1 and j is #list.
---@overload fun<T>(list: T[]|std__Packed<T>): T...
---@overload fun<T>(list: T[]|std__Packed<T>, i: number): T...
---@generic T
---@param list T[]|std__Packed<T>
---@param i number
---@param j number
---@return T...
function tbl.unpack(list, i, j)
    return table.unpack(list, i, j)
end

--endregion



---@generic T
---@param a T
---@param b T
---@return boolean
function __internal.tbl.defaultEqualsFunction(a, b)
    return a == b
end


---@generic K, V
---@param t table<K, V>
---@param tk K
---@param equator fun(this: K, other: K): boolean
---@return V | nil
function tbl.getWhereKeyEquals(t, tk, equator)
    for k, v in pairs(t) do
        if equator(tk, k) then
            return v
        end
    end

    return nil
end

---@generic T
---@param t T[]
---@param o T
---@param equalsFunction fun(a: T, b: T): boolean
---@return boolean
---@overload fun<K, V>(t: table<K, V>, o: V, equalsFunction: fun(a: V, b: V): boolean): boolean
---@overload fun<T>(t: T[], o: T): boolean
---@overload fun<K, V>(t: table<K, V>, o: V): boolean
function tbl.contains(t, o, equalsFunction)
    if equalsFunction == nil then
        equalsFunction = __internal.tbl.defaultEqualsFunction
    end

    for _, v in pairs(t) do
        if v == o then
            return true
        end
    end

    return false
end

---@generic K, V
---@param t table<K, V>
---@param o table<K, V>
---@return boolean
function tbl.contentsEqual(t, o)
    if t == o then
        return true
    end

    for k, v in pairs(t) do
        if v ~= o[k] then
            return false
        end
    end

    for k, _ in pairs(o) do
        if t[k] ~= nil then
            return false
        end
    end

    return true
end

---@generic T
---@param t T[]
---@param o T[]
---@return boolean
function tbl.arrayContentsEqual(t, o)
    if t == o then
        return true
    end

    local size = #t

    if size ~= #o then
        return false
    end

    for i = 1, size do
        if t[i] ~= o[i] then
            return false
        end
    end

    return true
end

---@generic T
---@param t T[]
---@return boolean
---@overload fun(table): boolean
---@overload fun<K, V>(table<K, V>): boolean
function tbl.isEmpty(t)
    for k, v in pairs(t) do
        return false
    end

    return true
end

---@generic T
---@param t T[]
---@param item T
---@vararg T
function tbl.add(t, item, ...)
    table.insert(t, item)

    for _, otherItem in ipairs({...}) do
        table.insert(t, otherItem)
    end
end

---@generic T
---@param t T[]
---@param items T[]
function tbl.addAll(t, items)
    for _, v in ipairs(items) do
        table.insert(t, v)
    end
end

---@generic K
---@generic V
---@param t table<K, V>
---@return V[]
function tbl.valuesOf(t)
    ---@type V[]
    local result = {}

    for _, v in pairs(t) do
        table.insert(result, v)
    end

    return result
end

---@generic K
---@generic V
---@param t table<K, V>
---@return K[]
function tbl.keysOf(t)
    ---@type K[]
    local result = {}

    for k, _ in pairs(t) do
        table.insert(result, k)
    end

    return result
end

---@generic K
---@generic V
---@param t table<K, V>
---@return table<K, V>
---@overload fun(t: table): table
---@overload fun<T>(t: T[]): T[]
function tbl.clone(t)
    ---@type table<K, V>
    local result = {}

    for k, v in pairs(t) do
        result[k] = v
    end

    return result
end

---@generic K
---@generic V
---@param t table<K, V>
---@return table<V, K>
function tbl.withSwappedKeysAndValues(t)
    ---@type table<V, K>
    local result = {}

    for k, v in pairs(t) do
        result[v] = k
    end

    return result
end

---@generic K
---@generic VInput
---@generic VOutput
---@param t table<K, VInput>
---@param f fun(inputK: K, inputV: VInput): VOutput
---@return table<K, VOutput>
---@overload fun<TInput, TOutput>(TInput[], fun(inputK: number, inputV: TInput): TOutput): TOutput[]
function tbl.transformed(t, f)
    ---@type table<K, VOutput>
    local result = {}

    for k, v in pairs(t) do
        result[k] = f(k, v)
    end

    return result
end

---@generic T
---@param t T[]
---@return T[]
function tbl.shuffled(t)
    local result = {}

    for _, item in ipairs(t) do
        table.insert(result, math.random(#result + 1), item)
    end

    return result
end

---@generic T
---@param t T[]
---@param byHowMany number
---@return T[]
function tbl.cycled(t, byHowMany)
    if byHowMany == nil then
        byHowMany = 1
    else
        byHowMany = (byHowMany % #t)
    end

    if byHowMany < 0 then
        byHowMany = byHowMany + #t
    end

    ---@type T[]
    local result = {}

    for i = byHowMany + 1, #t do
        table.insert(result, t[i])
    end

    for i = 1, byHowMany do
        table.insert(result, t[i])
    end

    return t
end

---@generic T
---@param t T[]
---@return T[]
function tbl.cycledRandomly(t)
    return tbl.cycled(t, math.random(1, #t))
end

---@generic T
---@param t1 T[]
---@param t2 T[]
---@param equalsFunction nil | fun(a: T, b: T): boolean
---@return T[]
---@overload fun<T>(t1: T[], t2: T[]): T[]
function tbl.intersection(t1, t2, equalsFunction)
    ---@type T[]
    local result = {}

    if equalsFunction == nil then
        equalsFunction = __internal.tbl.defaultEqualsFunction
    end

    for _, item in ipairs(t1) do
        if tbl.contains(t2, item, equalsFunction) then
            table.insert(result, item)
        end
    end

    return result
end


---@param item any
---@param levels number
---@param showKeysInSubTables boolean
---@param showValuesInSubTables boolean
---@return string
function __internal.tbl.itemToString(item, levels, showKeysInSubTables, showValuesInSubTables)
    local itemType = type(item)

    if itemType == "string" then
        return "\"" .. item .. "\""
    elseif itemType == "table" then
        return tbl.toString(item, levels - 1, showKeysInSubTables, showValuesInSubTables)
    else
        return tostring(item)
    end
end

---@param this string
---@return string
function __internal.tbl.indentString(this)
    if level == nil then
        level = 1
    end

    if this:sub(-1) ~= "\n" then
        this = this .. "\n"
    end

    ---@type string[]
    local lines = {}

    for line in this:gmatch("(.-)\n") do
        table.insert(lines, "    " .. line)
    end

    return table.concat(lines, "\n")
end
---@generic T
---@param t table<T, any>
---@return T[]
function __internal.tbl.getKeysSorted(t)
    ---@type T[]
    local numberKeys = {}
    ---@type T[]
    local stringKeys = {}
    ---@type T[]
    local otherKeys = {}

    for k, _ in pairs(t) do
        local ktype = type(k)

        if ktype == "number" then
            table.insert(numberKeys, k)
        elseif ktype == "string" then
            table.insert(stringKeys, k)
        else
            table.insert(otherKeys, k)
        end
    end

    table.sort(numberKeys)
    table.sort(stringKeys)

    ---@type T[]
    local combinedResult = {}

    for _, k in ipairs(numberKeys) do
        table.insert(combinedResult, k)
    end

    for _, k in ipairs(stringKeys) do
        table.insert(combinedResult, k)
    end

    for _, k in ipairs(otherKeys) do
        table.insert(combinedResult, k)
    end

    return combinedResult
end

---@param t table
---@param levels number
---@param includeKeys boolean
---@param includeValues boolean
---@return string
---@overload fun(t: table, levels: number, includeKeys: boolean): string
---@overload fun(t: table, levels: number): string
---@overload fun(t: table): string
function tbl.toString(t, levels, includeKeys, includeValues)
    if levels == 0 then
        return tostring(t)
    elseif levels == nil then
        levels = 1
    end

    if includeKeys == nil then
        includeKeys = true
    end

    if includeValues == nil then
        includeValues = true
    end

    if not (includeKeys or includeValues) then
        return "{\n}"
    end

    local encloseKeyInSquareBrackets = includeKeys and includeValues
    local keys = __internal.tbl.getKeysSorted(t)
    local result = ""
    local previousWasTable = false

    if #keys == 0 then
        return "{}"
    end

    if includeKeys then
        if includeValues then
            for n, k in ipairs(keys) do
                local v = t[k]
                local vIsTable = type(v) == "table"

                if previousWasTable or (vIsTable and n ~= 1) then
                    result = result .. "\n"
                end

                result = result .. "[" .. tostring(k) .. "] = "

                if vIsTable then
                    result = result .. "table" .. "\n"
                end

                result = result .. __internal.tbl.itemToString(v, levels, true, true) .. ",\n"
                previousWasTable = vIsTable
            end
        else
            for n, k in ipairs(keys) do
                local kIsTable = type(k) == "table"

                if previousWasTable or (kIsTable and n ~= 1) then
                    result = result .. "\n"
                end

                if kIsTable then
                    result = result .. "table\n"
                end

                result = result .. __internal.tbl.itemToString(k, levels, true, false) .. ",\n"
                previousWasTable = kIsTable
            end
        end
    else
        for n, k in ipairs(keys) do
            local v = t[k]
            local vIsTable = type(v) == "table"

            if previousWasTable or (vIsTable and n ~= 1) then
                result = result .. "\n"
            end

            if vIsTable then
                result = result .. "table\n"
            end

            result = result .. __internal.tbl.itemToString(v, levels, false, true) .. ",\n"
            previousWasTable = vIsTable
        end
    end

    -- The :sub call and extra newline gets rid of the trailing comma
    return "{\n" .. __internal.tbl.indentString(result:sub(1, -3)) .. "\n}"
end



return "LuaBundle bug workaround. Without this line, required scripts run multiple times."
