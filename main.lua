require 'code/lib/misc'
require 'code/src/game'
require 'code/src/player'
require 'code/src/fuel'
require 'code/src/container'
require 'code/src/director'
require 'code/lib/anal'

function love.load()
    -- canvas
    nativeWindowWidth = 1280
    nativeWindowHeight = 720

    nativeCanvasWidth = 1280
    nativeCanvasHeight = 720

    canvas = love.graphics.newCanvas(nativeCanvasWidth, nativeCanvasHeight)
    canvas:setFilter('linear', 'linear', 2) 
 
    -- assets
    -- fonts
    fonts = {}
    fonts.huge = love.graphics.newFont('assets/fonts/SF Atarian System.ttf', 256)
    fonts.large = love.graphics.newFont('assets/fonts/SF Atarian System.ttf', 128)

    -- gambar
    love.graphics.setDefaultFilter('nearest', 'nearest', 0.5)

    images = {}
    images.ground = love.graphics.newImage('assets/images/ground.png')
    images.fuel = love.graphics.newImage('assets/images/fuel.png')

    -- animasi
    animations = {}
    animations.player = {}
    local frameTime = 0.15
    animations.player.up = newAnimation(love.graphics.newImage('assets/images/player/naik.png'), 128, 128, frameTime, 4)
    animations.player.down = newAnimation(love.graphics.newImage('assets/images/player/turun.png'), 128, 128, frameTime, 4)
    animations.player.left = newAnimation(love.graphics.newImage('assets/images/player/kiri.png'), 128, 128, frameTime, 4)
    animations.player.right = newAnimation(love.graphics.newImage('assets/images/player/kanan.png'), 128, 128, frameTime, 4)

    -- musik
    music = {}
    music.main = love.audio.newSource('assets/music/bgmusic.mp3', 'stream')
    music.main:setVolume(0.4)
    music.main:setLooping(true)

    -- sounds
    sounds = {}
    sounds.walk = love.audio.newSource('assets/sounds/engines.wav', 'static')
    sounds.walk:setVolume(0.4)
    --sounds.walk:setLooping(true)
    sounds.fuel = love.audio.newSource('assets/sounds/fuel.wav', 'static')
    sounds.selesai = love.audio.newSource('assets/sounds/over.mp3', 'static')
    sounds.selesai:setVolume(0.3)
    -- seed random function
    math.randomseed(os.time())

    -- game
    game = Game:new('Menu')
end


function love.update(dt)
    -- determine window scale and offset
    windowScaleX = love.graphics.getWidth() / nativeWindowWidth
    windowScaleY = love.graphics.getHeight() / nativeWindowHeight
    windowScale = math.min(windowScaleX, windowScaleY)
    windowOffsetX = round((windowScaleX - windowScale) * (nativeWindowWidth * 0.5))
    windowOffsetY = round((windowScaleY - windowScale) * (nativeWindowHeight * 0.5))

    -- update game
    game:update(dt)
end


function love.draw()
    -- menggambar semua asset ke kanvas sesuai ukuran native, kemudian upscale dan offset
    love.graphics.setCanvas(canvas)
    game:draw()
    love.graphics.setCanvas()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(canvas, windowOffsetX, windowOffsetY, 0, windowScale, windowScale)

    -- letterboxing
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', windowWidth - windowOffsetX, 0, windowOffsetX, windowHeight)
    love.graphics.rectangle('fill', 0, 0, windowWidth, windowOffsetY)
    love.graphics.rectangle('fill', 0, windowHeight - windowOffsetY, windowWidth, windowOffsetY)
end