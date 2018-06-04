--[[
    GD50 2018
    Pong Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

Paddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.dyOld=0;
    self.momentum = 0
    self.yOld = self.y;
end

function Paddle:update(dt)
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    if(self.dyOld ~= self.dy or self.dy == 0 or self.yOld == self.y) then
        self.momentum = 0
    else 
        self.momentum = self.momentum+1
    end
    
    self.dyOld = self.dy
    self.yOld = self.y
end

function Paddle:auto(ball, PADDLE_SPEED)
    self.dy = 0
    if not paddleWillHitBall(self, ball) then
        if (ball.y < self.y) then
            self.dy = -PADDLE_SPEED
        elseif ( (ball.y + ball.height) > (self.y + self.height)) then
            self.dy = PADDLE_SPEED
        end
    end
end

paddleWillHitBall = function(paddle)

    local projectY = projectBall(paddle)

    if(projectY == nil) then
        return true;
    end

    if ((projectY < paddle.y) or (projectY + ball.height > paddle.y + paddle.height)) then
        return false
    else
        return true
    end
end

projectBall = function(paddle)
    halfWidth = (math.floor(VIRTUAL_WIDTH / 2) - 1 )

    local ballX = ball.x
    local ballY = ball.y

    if ( paddle.x < halfWidth ) and ( ball.dx < 0 ) then
        -- left paddle --> dx < 0
        
        while(ballX <= 0) do
            ballX = ballX + ball.dx
            ballY = ballY + ball.dy
        end

        return ballY
        
    elseif ( paddle.x >= halfWidth ) and ( ball.dx > 0 )  then
        -- right paddle --> dx > 0

        while (ballX + ball.width >= VIRTUAL_WIDTH) do
            ballX = ballX + ball.dx
            ballY = ballY + ball.dy
        end

        return ballY
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function Paddle:render()
    --print(self.x, self.y, self.width, self.height)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    -- love.graphics.line(self.x, math.floor(self.height / 2 + self.y), ball.x, math.floor(ball.vCenter + ball.y))
    -- love.graphics.line(self.x, self.y, ball.x, math.floor(ball.vCenter + ball.y))
    -- love.graphics.line(self.x, self.y + self.height, ball.x, math.floor(ball.vCenter + ball.y))
    -- love.graphics.points(self.x + self.width + 1, self.y + self.height / 2)
end