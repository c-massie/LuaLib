require("scot.massie.lua.lib.TableUtils")

function assertTrue(actual)
    if actual ~= true then
        error("\nExpected value to be true, was: " .. tostring(actual), 2)
    end
end

function assertFalse(actual)
    if actual ~= false then
        error("\nExpected value to be false, was: " .. tostring(actual), 2)
    end
end

function assertEqual(expected, actual)
    if expected ~= actual then
        error("\nExpected value: " .. tostring(expected) .. "\nActual value:   " .. tostring(actual), 2)
    end
end

function assertNotEqual(notExpected, actual)
    if notExpected == actual then
        error("\nUnexpected value: " .. tostring(actual), 2)
    end
end

function assertNil(actual)
    if actual ~= nil then
        error("\nExpected value to be nil, was: " .. tostring(actual), 2)
    end
end

function assertNotNil(actual)
    if actual == nil then
        error("\nExpected value not to be nil, was nil", 2)
    end
end

function assertOfType(actual, ...)
    local expectedTypeNames = { ... }
    local actualTypeName = type(actual)

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

function assertIsBool    (actual) assertOfType(actual, "boolean") end
function assertIsNumber  (actual) assertOfType(actual, "number") end
function assertIsString  (actual) assertOfType(actual, "string") end
function assertIsFunction(actual) assertOfType(actual, "function", "CFunction") end
function assertIsTable   (actual) assertOfType(actual, "table") end
function assertIsThread  (actual) assertOfType(actual, "thread") end
function assertIsUserdata(actual) assertOfType(actual, "userdata") end
