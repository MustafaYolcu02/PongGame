local love = require("love")

local player1 = {}
local player2 = {}
local ball = {}

local windowHeight = 600
local windowWidth = 800
local isFullScreen = false

local f11Pressed

local font

local isGame = false

local winningScore = 3

function love.load()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setFullscreen(isFullScreen)

    player1.width = 10
    player1.height = 60
    player1.x = 30
    player1.y = windowHeight / 2 - player1.height / 2
    player1.speed = 2
    player1.score = 0

    player2.width = 10
    player2.height = 60
    player2.x = windowWidth - player2.width - 30
    player2.y = windowHeight / 2 - player2.height / 2
    player2.speed = 2
    player2.score = 0

    ball.radius = 15
    resetBall()

    font = love.graphics.newFont(20)
    love.graphics.setFont(font)
end

function love.update(dt)
    if love.keyboard.isDown("f11") and not f11Pressed then
        isFullScreen = not isFullScreen
        love.window.setFullscreen(isFullScreen)
        f11Pressed = true
    elseif not love.keyboard.isDown("f11") then
        f11Pressed = false
    end

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if love.keyboard.isDown("g") then
        if not isGame then
            isGame = true
        end
        resetGame()
    end
    if isGame then
        movePlayers()
        moveBall()
    end
end

function love.draw()
    if isGame then
        love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)
        love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)

        local gameName = "PONG GAME"
        local textWidth = font:getWidth(gameName)
        local x = (windowWidth - textWidth) / 2
        love.graphics.printf(gameName, x, 10, windowWidth, "left")

        local scoreText1 = "Score: " .. player1.score
        local scoreText2 = "Score: " .. player2.score

        love.graphics.printf(scoreText1, 10, 10, windowWidth / 2, "left")
        love.graphics.printf(scoreText2, windowWidth / 2, 10, windowWidth / 2, "right")

        if player1.score == winningScore then
            love.graphics.printf("Winner is PLAYER1", 300, 300, windowWidth / 2, "left")
            isGame = false
        elseif player2.score == winningScore then
            love.graphics.printf("Winner is PLAYER2", 300, 300, windowWidth / 2, "left")
            isGame = false
        end
    else
        if player1.score == winningScore then
            love.graphics.printf("Winner is PLAYER1", 300, 300, windowWidth / 2, "left")
        elseif player2.score == winningScore then
            love.graphics.printf("Winner is PLAYER2", 300, 300, windowWidth / 2, "left")
        end
        love.graphics.print("Press G to Start", 300, 330)
    end
end


function movePlayers()
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed
    end
    if love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed
    end
    if love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed
    end
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed
    end
end

function moveBall()
    ball.x = ball.x + ball.speedX
    ball.y = ball.y + ball.speedY

    if ball.y - ball.radius < 0 or ball.y + ball.radius > windowHeight then
        ball.speedY = -ball.speedY
    end
    if ball.x - ball.radius < 0 or ball.x + ball.radius > windowWidth then
        ball.speedX = -ball.speedX

        if ball.x < windowWidth / 2 then
            player2.score = player2.score + 1
        else
            player1.score = player1.score + 1
        end

        resetBall()
    end

    if checkCollision(player1) then
        ball.speedX = math.abs(ball.speedX)
    end

    if checkCollision(player2) then
        ball.speedX = -math.abs(ball.speedX)
    end
end

function resetBall()
    ball.x = windowWidth / 2
    ball.y = windowHeight / 2
    ball.speedX = math.random(2) == 1 and 2 or -2
    ball.speedY = math.random(2) == 1 and 2 or -2
end

function checkCollision(player)
    return ball.x - ball.radius < player.x + player.width and
           ball.x + ball.radius > player.x and
           ball.y - ball.radius < player.y + player.height and
           ball.y + ball.radius > player.y
end

function resetGame()
    player1.score = 0
    player2.score = 0
    resetBall()
end