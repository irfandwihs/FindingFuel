local class = require 'code/lib/middleclass'

Fuel = class('Fuel')

function Fuel:initialize(x, y)
    self.x = x
    self.y = y

    self.radius = 28

    self.timeToLive = 6.5
end

function Fuel:update(dt)
    -- cek kondisi ketika mobil menabrak fuel
    local dx = game.player.x - self.x
    local dy = game.player.y - self.y
    local d = math.sqrt(dx ^ 2 + dy ^ 2)
    if d < self.radius + game.player.radius then
        -- score
        game.score = game.score + 10

        -- sfx
        sounds.fuel:stop()
        sounds.fuel:play()

        self.to_delete = true
    end

    self.timeToLive = self.timeToLive - dt

    -- cek timer
    if self.timeToLive < 0 then
        self.to_delete = true
    end
end

function Fuel:draw()
    -- membuat fuel berkedip sebelum hilang
    if self.timeToLive > 1.5 or math.sin(5 * self.timeToLive * 2 * math.pi) > 0 then
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(images.fuel, self.x, self.y, 0, 1, 1, 28, 28)
    end
end
