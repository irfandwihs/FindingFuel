local class = require 'code/lib/middleclass'
local stateful = require 'code/lib/stateful'

Game = class('Game')
Game:include(stateful)

function Game:initialize(state)
    self:gotoState(state)
end

Menu = Game:addState('Menu')
Play = Game:addState('Play')
GameOver = Game:addState('GameOver')

-- Menu

function Menu:update(dt)
    -- memulai permainan ketika pemain menekan tombol
    if love.keyboard.isDown('space', 'return', 'up', 'down', 'left', 'right', 'w', 's', 'a', 'd') then
        self:gotoState('Play')
        return
    end
end

function Menu:draw()
    -- menggambar background
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    -- menggambar judul
    love.graphics.setFont(fonts.huge)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('Finding Fuel', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 200, 1050, 'center')

    -- tekan mulai/start
    if math.cos(2 * math.pi * love.timer.getTime()) > 0 then
        love.graphics.setFont(fonts.large)
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf('Press Start', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 + 50, 1000, 'center')
    end
end

-- Play

function Play:enteredState()
    -- music
    music.main:play()

    self.player = Player:new()
    self.director = Director:new()
    self.obj = Container:new()

    -- skor
    self.score = 0

    -- timer
    self.timeLeft = 100
end

function Play:update(dt)
    self.player:update(dt)
    self.director:update(dt)
    self.obj:update(dt)

    -- update timer
    self.timeLeft = self.timeLeft - dt
    if self.timeLeft < 0 then
        self:gotoState('GameOver')
        return
    end

    -- kembali ke menu
    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
        return
    end
end

function Play:draw()
    -- menggambar background
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    self.obj:draw()
    self.player:draw()

    -- menampilkan skor
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(self.score, nativeCanvasWidth - 1000 - 20, 0, 1000, 'right')

    -- menampilkan timer
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(255, 255, 255)
    local seconds = round(self.timeLeft)
    if seconds < 10 then
        if math.cos(self.timeLeft * 12) > 0 then
            love.graphics.printf('0' .. seconds, 20, 0, 1000, 'left')
        end
    else
        love.graphics.printf('0' .. seconds, 20, 0, 1000, 'left')
    end
end

function Play:exitedState()
    -- music
    music.main:stop()
end

-- GameOver

function GameOver:enteredState()
    -- sound effect
    sounds.selesai:play()

    -- timer
    self.initTime = love.timer.getTime()
end

function GameOver:update(dt)
    -- kembali ke menu setelah 10 detik
    if love.timer.getTime() - self.initTime > 10 then
        self:gotoState('Menu')
        return
    end

    -- kembali ke menu
    if love.keyboard.isDown('escape') then
        self:gotoState('Menu')
        return
    end
end

function GameOver:draw()
    -- menggambar background
    love.graphics.setColor(255, 255, 255)
    local w = images.ground:getWidth()
    local h = images.ground:getHeight()
    for x = 0, nativeCanvasWidth, w do
        for y = 0, nativeCanvasHeight, h do
            love.graphics.draw(images.ground, x, y)
        end
    end

    -- menampilkan skor
    love.graphics.setFont(fonts.large)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('Your point : ' .. self.score .. ' ', nativeCanvasWidth / 2 - 500, nativeCanvasHeight / 2 - 100, 1000, 'center')
end

function GameOver:exitedState()
    -- sound effect
    sounds.selesai:stop()
end
