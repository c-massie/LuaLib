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
    withoutInRange
    withoutAll
    withoutWhere

    remove
    removeAt
    removeFirst
    removeLast
    removeInRange
    removeAll
    removeWhere
    clear

    toTable
    toString
    clone
]]

-- TO DO: Continue writing.




---@return number
function List:size()
    error("Not implemented yet")
    return --[[---@type number]] nil
end

---@return boolean
function List:isEmpty()
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@return boolean
function List:hasAnything()
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end


---@return boolean
function List:contains(item)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@return boolean
function List:containsAll(items)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@return boolean
function List:containsAny(items)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@return boolean
function List:containsOnly(items)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@return boolean
function List:containsSameItemsAs(items)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@param items Collection<T>
---@return boolean
function List:containsExactly(items)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end

---@param items List<T>
---@return boolean
function List:containsExactlyInSameOrder(items)
    error("Not implemented yet")
    return --[[---@type boolean]] nil
end


---@param index number
---@return T
function List:get(index)
    error("Not implemented yet")
    return --[[---@type T]] nil
end

---@return T
function List:getFirst()
    error("Not implemented yet")
    return --[[---@type T]] nil
end

---@return T
function List:getLast()
    error("Not implemented yet")
    return --[[---@type T]] nil
end

---@param fromInclusive number
---@param toExclusive number
---@return List<T>
function List:getSublist(fromInclusive, toExclusive)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:getWhere(predicate)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:getAlsoIn(other)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:getNotIn(other)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end


---@return (fun(beingIteratedOver: List<T>, previousItem: T): T), List<T>, number
function List:each()
    error("Not implemented yet")
    return --[[---@type (fun(beingIteratedOver: List<T>, previousItem: T): T), List<T>, number]] nil
end

---@return (fun(beingIteratedOver: List<T>, previousIndex: number): number, T), List<T>, number
function List:eachWithIndex()
    error("Not implemented yet")
    return --[[---@type (fun(beingIteratedOver: List<T>, previousIndex: number): number, T), List<T>, number]] nil
end

---@return (fun(beingIteratedOver: List<T>, previousIndex: number): number, T), List<T>, number
function List:eachInOrder()
    error("Not implemented yet")
    return --[[---@type (fun(beingIteratedOver: List<T>, previousIndex: number): number, T), List<T>, number]] nil
end


function List:reverse()
    error("Not implemented yet")
end

function List:shuffle()
    error("Not implemented yet")
end

---@param NumberOfPlacesToCycle number
function List:cycle(NumberOfPlacesToCycle)
    error("Not implemented yet")
end

function List:cycleRandomly()
    error("Not implemented yet")
end


---@return List<T>
function List:reversed()
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:shuffled()
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@param NumberOfPlacesToCycle number
---@return List<T>
function List:cycled(NumberOfPlacesToCycle)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:cycledRandomly()
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end


---@generic NT
---@return List<NT>
function List:transformed(transformer)
    error("Not implemented yet")
    return --[[---@type List<NT>]] nil
end


---@return List<T>
function List:with(item)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:withAll(items)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end


function List:add(item)
    error("Not implemented yet")
end

function List:addAll(items)
    error("Not implemented yet")
end


---@param index number
---@param item T
function List:set(index, item)
    error("Not implemented yet")
end


---@return List<T>
function List:without(item)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@param index number
---@return List<T>
function List:withoutAt(index)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@param amount number | nil
---@return List<T>
function List:withoutFirst(amount)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@param amount number | nil
---@return List<T>
function List:withoutLast(amount)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@param fromInclusive number
---@param toExclusive number
---@return List<T>
function List:withoutInRange(fromInclusive, toExclusive)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end


---@return List<T>
function List:withoutAll(items)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end

---@return List<T>
function List:withoutWhere(predicate)
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end


function List:remove(item)
    error("Not implemented yet")
end

---@param index number
function List:removeAt(index)
    error("Not implemented yet")
end

---@param amount number | nil
function List:removeFirst(amount)
    error("Not implemented yet")
end

---@param amount number | nil
function List:removeLast(amount)
    error("Not implemented yet")
end

---@param fromInclusive number
---@param toExclusive number
function List:removeInRange(fromInclusive, toExclusive)
    error("Not implemented yet")
end

function List:removeAll(items)
    error("Not implemented yet")
end

function List:removeWhere(predicate)
    error("Not implemented yet")
end

function List:clear()
    error("Not implemented yet")
end


---@return T[]
function List:toTable()
    error("Not implemented yet")
    return --[[---@type T[] ]] nil
end

---@return string
function List:toString()
    error("Not implemented yet")
    return --[[---@type string]] nil
end

---@return List<T>
function List:clone()
    error("Not implemented yet")
    return --[[---@type List<T>]] nil
end




