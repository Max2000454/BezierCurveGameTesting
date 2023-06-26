--[[
bezier curves:
    - three lerps --> lerp along those lines --> main curve (controlled by t (0 --> 1))
]]

local p0 = game.Workspace.BezierTest1Folder.p0.Position
local p1 = game.Workspace.BezierTest1Folder.p1.Position
local p2 = game.Workspace.BezierTest1Folder.p2.Position
local p3 = game.Workspace.BezierTest1Folder.p3.Position
local marker = game.Workspace.BezierTest1Folder.marker

local function CubicBezier(t, p0, p1, p2 ,p3)
    return (1 - t)^3*p0 + 3*(1 - t)^2*t*p1 + 3*(1 - t)*t^2*p2 + t^3*p3
end

local function createLUT(segments, ...)
    local distSum = 0
    local sums = {}
    local step = 1/segments
    for i = 0, 1, step do
        local firstPoint = CubicBezier(i, ...)
        local secondPoint = CubicBezier(i + step, ...)
        local dist = (secondPoint - firstPoint).Magnitude
        table.insert(sums, distSum)
        distSum += dist
    end

    return sums
end

local Bezier = {}
Bezier.__index = Bezier

function Bezier.new(p0, p1, p2, p3)
    local self = setmetatable({}, Bezier)

    self._points = {p0, p1, p2, p3}

    return self
end

function Bezier:Calc(t)
    return CubicBezier(t, table.unpack(self._points))
end

local curve = Bezier.new(p0, p1, p2, p3)

for t = 0, 1, 0.01 do
    marker.Position = curve:Calc(t)
    task.wait(0.03)
end