require("scot.massie.lua.lib.PseudoClassUtils")

--region declaration of class Collection

---@class Collection<T>
--- Define fields/functions here
---@overload fun(): Collection<T>
Collection =
{}

__internal.Collection = {}

function __internal.Collection.constructor()
    error("Collection cannot be instantiated, it needs to be implemented by another type.")
end

makePseudoClass("Collection", Collection, __internal.Collection.constructor)
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
function Collection:size()
    error("Not implemented.")
    return 0
end

---@return boolean
function Collection:isEmpty()
    error("Not implemented.")
    return true
end

---@return boolean
function Collection:hasAnything()
    error("Not implemented.")
    return true
end


---@param item T
---@return boolean
function Collection:contains(item)
    error("Not implemented.")
    return true
end

---@param items Collection<T>
---@return boolean
function Collection:containsAll(items)
    error("Not implemented.")
    return true
end

---@param items Collection<T>
---@return boolean
function Collection:containsAny(items)
    error("Not implemented.")
    return true
end

---@param items Collection<T>
---@return boolean
function Collection:containsOnly(items)
    error("Not implemented.")
    return true
end

---@param items Collection<T>
---@return boolean
function Collection:containsSameItemsAs(items)
    error("Not implemented.")
    return true
end


---@param predicate fun(item: T): boolean
---@return Collection<T>
function Collection:getWhere(predicate)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end

---@param other Collection<T>
---@return Collection<T>
function Collection:getAlsoIn(other)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end

---@param other Collection<T>
---@return Collection<T>
function Collection:getNotIn(other)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end


---@return (fun(beingIteratedOver: Collection<T>, previousItem: T): T), Collection<T>, number
function Collection:each()
    error("Not implemented.")
    return --[[---@type (fun(beingIteratedOver: Collection<T>, previousItem: T): T), Collection<T>, number]] nil
end


---@generic NT
---@param transformer fun(x: T): NT
---@return Collection<NT>
function Collection:transformed(transformer)
    error("Not implemented.")
    return --[[---@type Collection<NT>]] nil
end


---@param item T
---@return Collection<T>
function Collection:with(item)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end

---@param items Collection<T>
---@return Collection<T>
function Collection:withAll(items)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end


---@param item T
function Collection:add(item)
    error("Not implemented.")
end

---@param items Collection<T>
function Collection:addAll(items)
    error("Not implemented.")
end


---@param item T
---@return Collection<T>
function Collection:without(item)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end

---@param items Collection<T>
---@return Collection<T>
function Collection:withoutAll(items)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end

---@param predicate fun(item: T): boolean
---@return Collection<T>
function Collection:withoutWhere(predicate)
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end


---@param item T
---@return boolean
function Collection:remove(item)
    error("Not implemented.")
    return --[[---@type boolean]] nil
end

---@param items Collection<T>
function Collection:removeAll(items)
    error("Not implemented.")
end

---@param predicate fun(item: T): boolean
function Collection:removeWhere(predicate)
    error("Not implemented.")
end

function Collection:clear()
    error("Not implemented.")
end


---@return T[]
function Collection:toTable()
    error("Not implemented.")
    return --[[---@type T[] ]] nil
end

---return string
function Collection:toString()
    error("Not implemented.")
    return --[[---@type string]] nil
end

---@return Collection<T>
function Collection:clone()
    error("Not implemented.")
    return --[[---@type Collection<T>]] nil
end
