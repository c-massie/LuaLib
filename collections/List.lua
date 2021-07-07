require("scot.massie.lua.lib.PseudoClassUtils")
require("scot.massie.lua.lib.TableUtils")
require("scot.massie.lua.lib.collections.Collection")

-- Having a dedicated pseudoclass for this allows for cleaner access to ordered collections of items.

--region declaration of class List

---@class List<T> : Collection<T>
---@field private content T[]
---@overload fun(): List<T>
---@overload fun(other: List<T>): List<T>
List =
{
    __parent = Collection,

    __fieldNames =
    {
        "content",
    },
}

__internal.List = {}

---@generic T
---@param other List<T>
---@overload fun<T>()
function __internal.List.constructor(other)
    ---@type T[]
    local content

    if other == nil then
        content = {}
    else
        content = --[[---@type T[] ]] tbl.clone(other.content)
    end

    return
    {
        content = content,
    }
end

makePseudoClass("List", List, __internal.List.constructor)

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
    containsExactly
    containsExactlyInSameOrder

    get
    getFirst
    getLast
    getInitial
    getFinal
    getSublist
    getWhere
    getAlsoIn (intersection)
    getNotIn

    each
    eachWithIndex
    eachInOrder

    reverse
    shuffle
    cycle
    cycleRandomly

    reversed
    shuffled
    cycled
    cycledRandomly

    transformed

    with
    withAll

    add
    addAll

    set

    without
    withoutAt
    withoutFirst
    withoutLast
    withoutInitial
    withoutFinal
    withoutInRange
    withoutAll
    withoutWhere

    remove
    removeAt
    removeFirst
    removeLast
    removeInitial
    removeFinal
    removeInRange
    removeAll
    removeWhere
    clear

    toTable
    toString
    clone
]]




---@return number
function List:size()
    return #self.content
end

---@return boolean
function List:isEmpty()
    return #self.content == 0
end

---@return boolean
function List:hasAnything()
    return #self.content > 0
end


---@return boolean
function List:contains(item)
    for k, v in pairs(self.content) do
        if item == v then
            return true
        end
    end

    return false
end

---@return boolean
function List:containsAll(items)
    for item in items:each() do
        if not self:contains(item) then
            return false
        end
    end

    return true
end

---@return boolean
function List:containsAny(items)
    for item in items:each() do
        if not self:contains(item) then
            return true
        end
    end

    return false
end

---@param items Collection<T>
---@return boolean
function List:containsOnly(items)
    return items:containsAll(self)
end

---@param items Collection<T>
---@return boolean
function List:containsSameItemsAs(items)
    return self:containsAll(items) and items:containsAll(self)
end

---@param items Collection<T>
---@return boolean
function List:containsExactly(items)
    local selfClone = self:clone()

    for item in items:each() do
        if not selfClone:remove(item) then
            return false
        end
    end

    return true
end

---@param items List<T>
---@return boolean
function List:containsExactlyInSameOrder(items)
    local thisSize = self:size()
    local thatSize = self:size()

    if thisSize ~= thatSize then
        return false
    end

    for i = 1, thisSize do
        if self.content[i] ~= items:get(i) then
            return false
        end
    end

    return true
end


---@param index number
---@return T
function List:get(index)
    if index <= 0 then
        error("Attempted to get at a 0 or negative index on a list.")
    end

    if index > self:size() then
        error("Attempted to get at index " .. tostring(index) .. " on a list of size " .. tostring(self:size()) .. ".")
    end

    return self.content[index]
end

---@return T
function List:getFirst()
    if self:isEmpty() then
        error("Attempted to get first item in an empty list.")
    end

    return self.content[1]
end

---@return T
function List:getLast()
    if self:isEmpty() then
        error("Attempted to get last item in an empty list.")
    end

    return self.content[#self.content]
end

---@param amount number
---@return List<T>
function List:getInitial(amount)
    local result = List()

    for i = 1, math.min(amount, #self.content) do
        result:add(self.content[i])
    end

    return result
end

function List:getFinal(amount)
    local result = List()
    local contentSize = #self.content

    for i = math.max(contentSize + 1 - amount, 1), contentSize do
        result:add(self.content[i])
    end

    return result
end

---@param fromInclusive number
---@param toExclusive number
---@return List<T>
function List:getSublist(fromInclusive, toExclusive)
    if toExclusive < fromInclusive then
        error("Attempted to get a sublist of a list where the upper bound was lower than the lower bound.")
    end

    local result = List()
    local contentSize = #self.content

    for i = math.max(1, fromInclusive), math.min(contentSize + 1, toExclusive) do
        result:add(self.content[i])
    end

    return result
end

---@param predicate fun(item: T): boolean
---@return List<T>
function List:getWhere(predicate)
    local result = List()

    for _, v in ipairs(self.content) do
        if predicate(v) then
            result:add(v)
        end
    end

    return result
end

---@param other Collection<T>
---@return List<T>
function List:getAlsoIn(other)
    local result = List()

    for _, v in ipairs(self.content) do
        if other:contains(v) then
            result:add(v)
        end
    end

    return result
end

---@param other Collection<T>
---@return List<T>
function List:getNotIn(other)
    local result = List()

    for _, v in ipairs(self.content) do
        if not other:contains(v) then
            result:add(v)
        end
    end

    return result
end


---@return (fun(beingIteratedOver: List<T>, previousItem: T): T)
function List:each()
    local i = 0

    return function(beingIteratedOver, previousItem)
        i = i + 1
        return self.content[i]
    end
end

---@return (fun(beingIteratedOver: List<T>, previousIndex: number): number, T), List<T>, number
function List:eachWithIndex()
    return
    ---@param v List<T>
    ---@param i number
    ---@return number, T
    function(v, i)
        i = i + 1

        if i <= #self.content then
            return i, self.content[i]
        end
    end, self, 0
end

---@return (fun(beingIteratedOver: List<T>, previousIndex: number): number, T), List<T>, number
function List:eachInOrder()
    return
    ---@param v List<T>
    ---@param i number
    ---@return number, T
    function(v, i)
        i = i + 1

        if i <= #self.content then
            return i, self.content[i]
        end
    end, self, 0
end

function List:reverse()
    local newContent = {}

    for i = #self.content, 1, -1 do
        table.insert(newContent, self.content[i])
    end

    self.content = newContent
end

function List:shuffle()
    self.content = tbl.shuffled(self.content)
end

---@param numberOfPlacesToCycle number
function List:cycle(numberOfPlacesToCycle)
    self.content = tbl.cycled(self.content, numberOfPlacesToCycle)
end

function List:cycleRandomly()
    self.content = tbl.cycledRandomly(self.content)
end


---@return List<T>
function List:reversed()
    local result = List()

    for i = #self.content, 1, -1 do
        result:add(self.content[i])
    end

    return result
end

---@return List<T>
function List:shuffled()
    local result = List()

    for _, item in pairs(self.content) do
        result:addAt(math.random(result:size() + 1), item)
    end

    return result
end

---@param numberOfPlacesToCycle number
---@return List<T>
function List:cycled(numberOfPlacesToCycle)
    if numberOfPlacesToCycle == nil then
        numberOfPlacesToCycle = 1
    else
        numberOfPlacesToCycle = (numberOfPlacesToCycle % #self.content)
    end

    if numberOfPlacesToCycle < 0 then
        numberOfPlacesToCycle = numberOfPlacesToCycle + #self.content
    end

    local result = List()

    for i = numberOfPlacesToCycle + 1, #self.content do
        result:add(self.content[i])
    end

    for i = 1, numberOfPlacesToCycle do
        result:add(self.content[i])
    end

    return result
end

---@return List<T>
function List:cycledRandomly()
    return self:cycled(math.random(1, self:size()))
end


---@generic NT
---@param transformer fun(x: T): NT
---@return List<NT>
function List:transformed(transformer)
    ---@type List<NT>
    local result = --[[---@type List<NT>]] List()

    for _, item in ipairs(self.content) do
        result:add(transformer(item))
    end

    return result
end

---@param item T
---@return List<T>
function List:with(item)
    local result = self:clone()
    result:add(item)
    return result
end

---@return List<T>
function List:withAt(index, item)
    local result = self:clone()
    result:addAt(index, item)
    return result
end

---@param items Collection<T>
---@return List<T>
function List:withAll(items)
    local result = self:clone()

    for item in items:each() do
        result:add(item)
    end

    return result
end

---@param item T
function List:add(item)
    table.insert(self.content, item)
end

---@param index number
---@param item T
function List:addAt(index, item)
    table.insert(self.content, index, item)
end

---@param items Collection<T>
function List:addAll(items)
    for item in items:each() do
        self:add(item)
    end
end


---@param index number
---@param item T
function List:set(index, item)
    if index <= 0 then
        error("Attempts to set a value at " .. index .. ", which is 0 or below, in a list.")
    end

    local size = #self.content

    if index > (size + 1) then
        error("Attempted to set a value at " .. tostring(index) .. " in a list of size " .. tostring(size))
    end

    self.content[index] = item
end


---@return List<T>
function List:without(item)
    local result = List()

    for _, v in ipairs(self.content) do
        if item ~= v then
            result:add(v)
        end
    end

    return result
end

---@param index number
---@return List<T>
function List:withoutAt(index)
    if index <= 0 then
        error("Attempted to get list without index of 0 or less.")
    end

    local size = #self.content

    if index > size then
        error("Attempted to get list without index of " .. tostring(index) .. " from a list of size " .. tostring(size))
    end

    local result = List()

    for i = 1, index - 1 do
        result:add(self.content[i])
    end

    for i = index + 1, size do
        result:add(self.content[i])
    end

    return result
end

---@return List<T>
function List:withoutFirst()
    local result = List()

    for i = 2, #self.content do
        result:add(self.content[i])
    end

    return result
end

---@return List<T>
function List:withoutLast()
    local result = List()

    for i = 1, #self.content - 1 do
        result:add(self.content[i])
    end

    return result
end

---@param amount number
---@return List<T>
function List:withoutInitial(amount)
    local result = List()

    for i = math.max(1, amount + 1), #self.content do
        result:add(self.content[i])
    end

    return result
end

---@param amount number
---@return List<T>
function List:withoutFinal(amount)
    local result = List()

    for i = 1, math.min(#self.content, #self.content - amount) do
        result:add(self.content[i])
    end

    return result
end

---@param fromInclusive number
---@param toExclusive number
---@return List<T>
function List:withoutInRange(fromInclusive, toExclusive)
    if toExclusive < fromInclusive then
        error("Attempted to get a list from another list without elements in a range where the upper bound was lower than the lower bound")
    end

    local result = LisT()

    for i = math.max(1, fromInclusive), math.min(#self.content, toExclusive - 1) do
        result:add(self.content[i])
    end

    return result
end


---@param items Collection<T>
---@return List<T>
function List:withoutAll(items)
    local result = List()

    for _, item in ipairs(self.content) do
        if not items:contains(item) then
            result:add(item)
        end
    end

    return result
end

---@param predicate fun(item: T): boolean
---@return List<T>
function List:withoutWhere(predicate)
    local result = List()

    for _, item in ipairs(self.content) do
        if not predicate(item) then
            result:add(item)
        end
    end

    return result
end

---@return boolean
function List:remove(item)
    ---@type number
    local positionToRemove = --[[---@type number]] nil

    for i, v in ipairs(self.content) do
        if item == v then
            positionToRemove = i
            break
        end
    end

    if positionToRemove ~= nil then
        table.remove(self.content, positionToRemove)
        return true
    else
        return false
    end
end

---@param index number
function List:removeAt(index)
    table.remove(self.content, index)
end

function List:removeFirst()
    if self:isEmpty() then
        error("Attempted to remove first element of an empty list.")
    end

    table.remove(self.content, 1)
end

function List:removeLast()
    if self:isEmpty() then
        error("Attempted to remove last element of an empty list.")
    end

    table.remove(self.content, #self.content)
end

---@param amount number
function List:removeInitial(amount)
    for i = 1, math.min(#self.content, amount) do
        table.remove(self.content, 1)
    end
end

---@param amount number
function List:removeFinal(amount)
    for i = 1, math.min(#self.content, amount) do
        table.remove(self.content)
    end
end

---@param fromInclusive number
---@param toExclusive number
function List:removeInRange(fromInclusive, toExclusive)
    if toExclusive < fromInclusive then
        error("Attempted to remove items from a list in a range where the upper bound was lower than the lower bound.")
    end

    for i = toExclusive - 1, fromInclusive, -1 do
        table.remove(self.content, i)
    end
end

function List:removeAll(items)
    for item in items:each() do
        self:remove(item)
    end
end

---@param predicate fun(item: T): boolean
function List:removeWhere(predicate)
    for i = #self.content, 1, -1 do
        if predicate(self.content[i]) then
            table.remove(self.content, i)
        end
    end
end

function List:clear()
    self.content = {}
end


---@return T[]
function List:toTable()
    ---@type T[]
    local result = {}

    for i, item in ipairs(self.content) do
        result[i] = item
    end

    return result
end

---@return string
function List:toString()
    local result = ""

    for _, item in ipairs(self.content) do
        result = result .. tostring(item) .. ", "
    end

    if result == "" then
        return "[]"
    end

    return "[" .. result:sub(1, #result - 2) .. "]"
end

---@return List<T>
function List:clone()
    local result = List()

    for _, item in ipairs(self.content) do
        result:add(item)
    end

    return result
end




