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



-- Class functions here.

-- TO DO: Write