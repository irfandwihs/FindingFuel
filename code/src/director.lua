local class = require 'code/lib/middleclass'

Director = class('Director')

function Director:initialize()
    self.lastFuelTime = love.timer.getTime()
end

function Director:update(dt)
    -- menambahkan fuel
    if #game.obj.contents < 5 then
        local currentTime = love.timer.getTime()

        if currentTime - self.lastFuelTime > 0.5 and chance(0.05) then
            local x = math.random(30, nativeCanvasWidth - 30)
            local y = math.random(30, nativeWindowHeight - 30)
            game.obj:add(Fuel:new(x, y))
            self.lastFuelTime = currentTime
        end
    end
end