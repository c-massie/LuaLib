require("scot.massie.lua.lib.InternalGlobalTable")
require("scot.massie.lua.lib.PseudoClassUtils")

--region XYCoOrd declaration

---@class XYCoOrd
---@field x number
---@field y number
---@overload fun(x: number, y: number): XYCoOrd
XYCoOrd = {}

__internal.XYCoOrd = {}

---@param x number
---@param y number
function __internal.XYCoOrd.constructor(x, y)
    return { x = x, y = y }
end

makePseudoClass("XYCoOrd", XYCoOrd, __internal.XYCoOrd.constructor)
makePseudoClassInternInstances(XYCoOrd)
--endregion

---@param this XYCoOrd
---@return string
function XYCoOrd.toString(this)
    return "(" .. tostring(this.x) .. ", " .. tostring(this.y) .. ")"
end

---@param this XYCoOrd
---@param other XYCoOrd
---@return number
function XYCoOrd.distanceTo(this, other)
    local xdist = this.x - other.x
    local ydist = this.y - other.y
    return math.sqrt(xdist * xdist + ydist * ydist)
end

---@param this XYCoOrd
---@param other XYCoOrd
---@return number
function XYCoOrd.distanceSqTo(this, other)
    local xdist = this.x - other.x
    local ydist = this.y - other.y
    return xdist * xdist + ydist * ydist
end




--region XYZCoOrd declaration

---@class XYZCoOrd
---@field x number
---@field y number
---@field z number
---@overload fun(x: number, y: number, z: number): XYZCoOrd
XYZCoOrd = {}

__internal.XYZCoOrd = {}

---@param x number
---@param y number
---@param z number
function __internal.XYZCoOrd.constructor(x, y, z)
    return { x = x, y = y, z = z }
end

makePseudoClass("XYZCoOrd", XYZCoOrd, __internal.XYZCoOrd.constructor)
makePseudoClassInternInstances(XYZCoOrd)
--endregion

---@param this XYZCoOrd
---@return string
function XYZCoOrd.toString(this)
    return "(" .. tostring(this.x) .. ", " .. tostring(this.y) .. ", " .. tostring(this.z) .. ")"
end

---@param this XYZCoOrd
---@param other XYZCoOrd
---@return number
function XYZCoOrd.distanceTo(this, other)
    local xdist = this.x - other.x
    local ydist = this.y - other.y
    local zdist = this.z - other.z
    return math.sqrt(xdist * xdist + ydist * ydist + zdist * zdist)
end

---@param this XYZCoOrd
---@param other XYZCoOrd
---@return number
function XYZCoOrd.distanceSqTo(this, other)
    local xdist = this.x - other.x
    local ydist = this.y - other.y
    local zdist = this.z - other.z
    return xdist * xdist + ydist * ydist + zdist * zdist
end




return "LuaBundle bug workaround. Without this line, required scripts run multiple times."
