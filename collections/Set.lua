require("scot.massie.lua.lib.PseudoClassUtils")

--region declaration of class Set

---@class Set<T> : Collection<T>
---@field content table<T, boolean>
---@field contentSize number
---@overload fun(): Set<T>
Set =
{
    -- Define parent class here and in @class with ": {parent class name}" after the class name.
    __parent = Collection,

    __fieldNames =
    {
        "content",
        "contentSize",
    },
}

__internal.Set = {}

---@generic T
---@param other Collection<T>
---@overload fun<T>()
function __internal.Set.constructor(other)
    ---@type table<T, boolean>
    local content = {}
    local contentSize = 0

    if other ~= nil then
        for item in other:each() do
            content[item] = true
        end
    end

    for v, _ in pairs(content) do
        contentSize = contentSize + 1
    end

    return
    {
        content = content,
        contentSize = contentSize,
    }
end

makePseudoClass("Set", Set, __internal.Set.constructor)

--endregion



-- Functions:
--[[
    size
    isEmpty
    hasAnything

    contains
    containsAll
    containsAny
    containsOnly
    containsSameItemsAs

    get
    getWhere
    getAlsoIn (intersection)
    getNotIn

    each

    transformed

    with
    withAll

    add
    addAll

    without
    withoutAll
    withoutWhere

    remove
    removeAll
    removeWhere
    clear

    toTable
    toString
    clone
]]



---@return number
function Set:size()
    return self.contentSize
end

---@return boolean
function Set:isEmpty()
    return self.contentSize == 0
end

---@return boolean
function Set:hasAnything()
    return self.contentSize > 0
end


---@param item T
---@return boolean
function Set:contains(item)
    return self.content[item] ~= nil
end

---@param items Collection<T>
---@return boolean
function Set:containsAll(items)
    for item in items:each() do
        if self.content[item] == nil then
            return false
        end
    end

    return true
end

---@param items Collection<T>
---@return boolean
function Set:containsAny(items)
    for item in items:each() do
        if self.content[item] ~= nil then
            return true
        end
    end

    return false
end

---@param items Collection<T>
---@return boolean
function Set:containsOnly(items)
    return items:containsAll(self)
end

---@param items Collection<T>
---@return boolean
function Set:containsSameItemsAs(items)
    return self:containsAll(items) and items:containsAll(self)
end


---@param predicate fun(item: T): boolean
---@return Set<T>
function Set:getWhere(predicate)
    local result = Set()

    for v, _ in pairs(self.content) do
        if predicate(v) then
            result:add(v)
        end
    end

    return result
end

---@param other Collection<T>
---@return Set<T>
function Set:getAlsoIn(other)
    local result = Set()

    for v, _ in pairs(self.content) do
        if other:contains(v) then
            result:add(v)
        end
    end

    return result
end

---@param other Collection<T>
---@return Set<T>
function Set:getNotIn(other)
    local result = Set()

    for v, _ in pairs(self.content) do
        if not other:contains(v) then
            result:add(v)
        end
    end

    return result
end


---@return (fun(beingIteratedOver: Set<T>, previousItem: T): T)
function Set:each()
    return
    ---@param this Set<T>
    ---@param previous T
    ---@return T
    function(this, previous)
        local current, _ = --[[---@type T, boolean]] next(this.content, previous)
        previous = current
        return current
    end
end


---@generic NT
---@param transformer fun(x: T): NT
function Set:transformed(transformer)
    ---@type Set<NT>
    local result = --[[---@type Set<NT>]]Set()

    for v, _ in pairs(self.content) do
        result:add(transformer(v))
    end

    return result
end


---@param item T
---@return Set<T>
function Set:with(item)
    local result = Set()

    for v, _ in pairs(self.content) do
        result:add(v)
    end

    result:add(item)
    return result
end

---@param items Collection<T>
---@return Set<T>
function Set:withAll(items)
    local result = Set()

    for v, _ in pairs(self.content) do
        result:add(v)
    end

    for v in items:each() do
        result:add(v)
    end

    return result
end


---@param item T
function Set:add(item)
    if self.content[item] == nil then
        self.content[item] = true
        self.contentSize = self.contentSize + 1
    end
end

---@param items Collection<T>
function Set:addAll(items)
    for item in items:each() do
        if self.content[item] == nil then
            self.content[item] = true
            self.contentSize = self.contentSize + 1
        end
    end
end


---@param item T
---@return Set<T>
function Set:without(item)
    local result = self:clone()
    result:remove(item)
    return result
end

---@param items Collection<T>
---@return Set<T>
function Set:withoutAll(items)
    local result = Set()

    for v, _ in pairs(self.content) do
        if not items:contains(v) then
            result:add(v)
        end
    end

    return result
end

---@param predicate fun(item: T): boolean
---@return Set<T>
function Set:withoutWhere(predicate)
    local result = Set()

    for v, _ in pairs(self.content) do
        if not predicate(v) then
            result:add(v)
        end
    end

    return result
end


---@param item T
---@return boolean
function Set:remove(item)
    local itemWasPresent = self.content[item] ~= nil

    if itemWasPresent then
        self.content[item] = nil
        self.contentSize = self.contentSize - 1
    end

    return itemWasPresent
end

---@param items Collection<T>
function Set:removeAll(items)
    for item in items:each() do
        if self.content[item] ~= nil then
            self.content[item] = nil
            self.contentSize = self.contentSize - 1
        end
    end
end

---@param predicate fun(item: T): boolean
function Set:removeWhere(predicate)
    local itemsToRemove = {}

    for v, _ in pairs(self.content) do
        if predicate(v) then
            table.insert(itemsToRemove, v)
        end
    end

    for _, v in pairs(itemsToRemove) do
        self.content[v] = nil
    end

    self.contentSize = self.contentSize - #itemsToRemove
end

function Set:clear()
    self.content = {}
    self.contentSize = 0
end


---@return T[]
function Set:toTable()
    local result = {}

    for v, _ in pairs(self.content) do
        table.insert(result, v)
    end

    return result
end

---@return string
function Set:toString()
    local result = ""

    for v, _ in pairs(self.content) do
        result = result .. tostring(v) .. ", "
    end

    if result == "" then
        return "[]"
    end

    return "[" .. result:sub(1, #result - 2) .. "]"
end

---@return Set<T>
function Set:clone()
    local result = Set()

    for v, _ in pairs(self.content) do
        result:add(v)
    end

    return result
end
