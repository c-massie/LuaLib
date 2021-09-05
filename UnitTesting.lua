require("scot.massie.lua.lib.TableUtils")
require("scot.massie.lua.lib.PseudoClassUtils")

--region class Assertion<T>
--region declaration of class Assertion

---@class Assertion
--- Define fields/functions here
---@field _actual any
---@overload fun(actual: any): Assertion
Assertion =
{}

__internal.Assertion = {}

function __internal.Assertion.constructor(actual)
    return { _actual = actual }
end

makePseudoClass("Collection", Collection, __internal.Collection.constructor)
--endregion

function Assertion:isTrue()
    if self._actual ~= true then
        error("\nExpected value to be true, was: " .. tostring(self._actual), 2)
    end
end

function Assertion:isFalse()
    if self._actual ~= false then
        error("\nExpected value to be false, was: " .. tostring(self._actual), 2)
    end
end

function Assertion:equals(expected)
    if expected ~= self._actual then
        error("\nExpected value: " .. tostring(expected) .. "\nActual value:   " .. tostring(self._actual), 2)
    end
end

function Assertion:doesntEqual(notExpected)
    if notExpected == self._actual then
        error("\nUnexpected value: " .. tostring(self._actual), 2)
    end
end

function Assertion:isNil()
    if self._actual ~= nil then
        error("\nExpected value to be nil, was: " .. tostring(self._actual), 2)
    end
end

function Assertion:isNotNil()
    if self._actual == nil then
        error("\nExpected value not to be nil, was nil", 2)
    end
end

function Assertion:isOfType(...)
    local expectedTypeNames = { ... }
    local actualTypeName = type(self._actual)

    for _, expectedTypeName in pairs(expectedTypeNames) do
        if actualTypeName == expectedTypeName then
            return
        end
    end

    if #expectedTypeNames == 1 then
        error("Expected value to be of type " .. expectedTypeNames[1] .. ", was actually of type: " .. actualTypeName)
        return
    end

    error("Expected value to be of one of the following types: [" .. tbl.joinStringsInOrder(expectedTypeNames, ", ")
            .. "], was actually of type: " .. actualTypeName)
end

function Assertion:isBool()     self:isOfType("boolean") end
function Assertion:isNumber()   self:isOfType("number") end
function Assertion:isString()   self:isOfType("string") end
function Assertion:isFunction() self:isOfType("function", "CFunction") end
function Assertion:isTable()    self:isOfType("table") end
function Assertion:isThread()   self:isOfType("thread") end
function Assertion:isUserData() self:isOfType("userdata") end

--endregion


---@return Assertion
function assertThat(actual)
    return Assertion(actual)
end
