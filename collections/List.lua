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
    getSublist
    getWhere
    getAlsoIn (intersection)
    getNotIn

    each
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
    withoutInRange

    remove
    removeAt
    removeFirst
    removeLast
    removeInRange
    clear

    toTable
    toString
    clone
]]

--region number of items

---@param this List<T>
function List.size(this)
    return #(this.content)
end

---@param this List<T>
function List.isEmpty(this)
    return #(this.content) == 0
end

---@param this List<T>
function List.hasAnything(this)
    return #(this.content) > 0
end

--endregion

--region contains

---@param this List<T>
---@param item T
function List.contains(this, item)
    for _, v in pairs(this.content) do
        if item == v then
            return true
        end
    end

    return false
end

--endregion

--region get

---@param this List<T>
---@param index number
function List.get(this, index)
    if index <= 0 then
        error("Attempts to access a list at a 0 or negative index, which was " .. tostring(index) .. ".")
    end

    local size = #(this.content)

    if index > size then
        error("Attempted to access a list of size " .. tostring(size) .. " at index " .. tostring(index) .. ".")
    end

    return this.content[index]
end

--endregion

--region add values

---@param this List<T>
---@param itemToAdd T
function List.add(this, itemToAdd)
    table.insert(this.content, itemToAdd)
end

--endregion

-- TO DO: Continue writing.


