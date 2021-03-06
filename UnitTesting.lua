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

__internal.Assertion.defaultEquator = function(a, b) return a == b end
__internal.Assertion.defaultComparator = function(a, b) return a < b end

function __internal.Assertion.constructor(actual)
    return
    {
        _actual     = actual,
        _equator    = __internal.Assertion.defaultEquator,
        _comparator = __internal.Assertion.defaultComparator,
    }
end

makePseudoClass("Collection", Collection, __internal.Collection.constructor)
--endregion

---@param equator fun(a: any, b: any): boolean
function Assertion:withEquator(equator)
    self._equator = equator
end

---@param comparator fun(a: any, b: any): boolean
function Assertion:withComparator(comparator)
    self._comparator = comparator
end

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
    if not self._equator(expected, self._actual) then
        error("\nExpected value: " .. tostring(expected) .. "\nActual value:   " .. tostring(self._actual), 2)
    end
end

function Assertion:doesntEqual(notExpected)
    if not self._equator(notExpected, self._actual) then
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



function Assertion:containsContentsOf(t)
    local missingValues = {}

    for _, v in ipairs(t) do
        if not tbl.contains(self._actual, v, self._equator) then
            tbl.add(missingValues, v)
        end
    end

    if #missingValues > 0 then
        local errorMsg = "Expected table to contain all expected values. Did not contain: "

        for _, v in ipairs(missingValues) do
            errorMsg = errorMsg .. "\n    " .. tostring(v)
        end

        error(errorMsg)
    end
end

function Assertion:containsNothingButContentsOf(t)
    local additionalValues = {}

    for _, v in pairs(self._actual) do
        if not tbl.contains(t, v, self._equator) then
            tbl.add(additionalValues, v)
        end
    end

    if #additionalValues > 0 then
        local errorMsg = "Table contained unexpected values: "

        for _, v in ipairs(additionalValues) do
            errorMsg = errorMsg .. "\n    " .. tostring(v)
        end

        error(errorMsg)
    end
end

---@generic T
---@param t T[]
function Assertion:containsExactlyContentsOf(t)
    local expectedValues = --[[---@type T[] ]]tbl.clone(t)
    local unexpectedValues = {}

    for _, v in pairs(self._actual) do
        local positionOfVInExpectedValues = tbl.indexOf(expectedValues, v, self._equator)

        if positionOfVInExpectedValues == nil then
            tbl.add(unexpectedValues, v)
        else
            tbl.remove(expectedValues, positionOfVInExpectedValues)
        end
    end

    if #expectedValues > 0 or #unexpectedValues > 0 then
        local errorMsg = "Table didn't match expected values.\nExpected values not present: "

        for _, v in ipairs(expectedValues) do
            errorMsg = errorMsg .. "    " .. tostring(v)
        end

        errorMsg = errorMsg .. "\n\nUnexpected values found: "

        for _, v in ipairs(unexpectedValues) do
            errorMsg = errorMsg .. "    " .. tostring(v)
        end

        error(errorMsg)
    end
end

function Assertion:contains(...)
    self:containsContentsOf({...})
end

function Assertion:containsNothingBut(...)
    self:containsNothingButContentsOf({...})
end

function Assertion:containsExactly(...)
    self:containsExactlyContentsOf({...})
end

---@param n number
function Assertion:hasSizeViaOperator(n)
    local size = #(self._actual)

    if size ~= n then
        error("Expected to have a size of " .. tostring(n) .. " as reported by the size operator (#), actually had a "
                + "size of " .. tostring(size) .. ".")
    end
end

function Assertion:hasSize(n)
    local size = 0

    for _, _ in pairs(self._actual) do
        size = size + 1
    end

    if size ~= n then
        error("Expected to have a size of " .. tostring(n) .. ", actually had a size of " .. tostring(size) .. ".")
    end
end

function Assertion:isEmptyViaOperator()
    if #(self._actual) ~= 0 then
        local errorMsg = "Expected to be empty as reported by the size operator (#), was not. Actually contained:"

        for k, v in ipairs(self._actual) do
            errorMsg = errorMsg .. "\n    " .. tostring(v)
        end
    end
end

function Assertion:isEmpty()
    for _ in pairs(self._actual) do
        local errorMsg = "Expected to be empty, was not. Actually contained:"

        for k, v in pairs(self._actual) do
            errorMsg = errorMsg .. "\n    " .. tostring(v)
        end
    end
end

function Assertion:isLessThan(x)
    if not (self._comparator(self._actual, x)) then
        error("Expected to be less than " .. tostring(x) .. ", was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isLessThanOrEqualTo(x)
    if self._comparator(x, self._actual) then
        error("Expected to be less than or equal to " .. tostring(x) .. ", was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isGreaterThan(x)
    if not self._comparator(x, self._actual) then
        error("Expected to be greater than " .. tostring(x) .. ", was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isGreaterThanOrEqualTo(x)
    if self._comparator(self._actual, x) then
        error("Expected to be greater than or equal to " .. tostring(x) .. ", was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isBetween(lowerBoundExclusive, upperBoundExclusive)
    if upperBoundExclusive < lowerBoundExclusive then
        local temp = lowerBoundExclusive
        lowerBoundExclusive = upperBoundExclusive
        upperBoundExclusive = temp
    end

    if not (self._comparator(lowerBoundExclusive, self._actual) and self._comparator(self._actual, upperBoundExclusive)) then
        error("Expected to be between " .. tostring(lowerBoundExclusive) .. " and " .. tostring(upperBoundExclusive)
                .. ", was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isBetweenInclusive(lowerBoundInclusive, upperBoundInclusive)
    if upperBoundInclusive < lowerBoundInclusive then
        local temp = lowerBoundInclusive
        lowerBoundInclusive = upperBoundInclusive
        upperBoundInclusive = temp
    end

    if not ((not self._comparator(self._actual, lowerBoundInclusive)) and (not self._comparator(upperBoundInclusive, self._actual))) then
        error("Expected to be between " .. tostring(lowerBoundInclusive) .. " (inclusive) and "
                .. tostring(upperBoundInclusive) .. " (inclusive), was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isBetweenInclusiveLower(lowerBoundInclusive, upperBoundExclusive)
    if upperBoundExclusive < lowerBoundInclusive then
        local temp = lowerBoundInclusive
        lowerBoundInclusive = upperBoundExclusive
        upperBoundExclusive = temp
    end

    if not ((not self._comparator(self._actual, lowerBoundInclusive)) and self._comparator(self._actual, upperBoundExclusive)) then
        error("Expected to be between " .. tostring(lowerBoundInclusive) .. " (inclusive) and "
                .. tostring(upperBoundExclusive) .. " (inclusive), was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isBetweenInclusiveUpper(lowerBoundExclusive, upperBoundInclusive)
    if upperBoundInclusive < lowerBoundExclusive then
        local temp = lowerBoundExclusive
        lowerBoundExclusive = upperBoundInclusive
        upperBoundInclusive = temp
    end

    if not (self._comparator(lowerBoundExclusive, self._actual) and (not self._comparator(upperBoundInclusive, self._actual))) then
        error("Expected to be between " .. tostring(lowerBoundExclusive) .. " (inclusive) and "
                .. tostring(upperBoundInclusive) .. " (inclusive), was " .. tostring(self._actual) .. ".")
    end
end

function Assertion:isPositive()
    if self._comparator(self._actual, 0) then
        error("Expected to be positive, was " .. tostring(self._actual))
    end
end

function Assertion:isNegative()
    if self._comparator(0, self._actual) then
        error("Expected to be negative, was " .. tostring(self._actual))
    end
end
--endregion


---@return Assertion
function assertThat(actual)
    return Assertion(actual)
end
