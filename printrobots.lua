local maxdistance=100

robot.register_error_handler(error)

local robot = require "robot"

math.randomseed(os.time()) math.random() math.random()
badrobot= robot.new(math.random(maxdistance))
redrobot= robot.new(-math.random(maxdistance))

io.write("Bot 1 X: ",badrobot.x,"\tBot 2 X: ",redrobot.x,"\n")
while badrobot.x~=redrobot.x do
  badrobot:step()
  redrobot:step()
  io.write("Bot 1 X: ",badrobot.x,"\tBot 2 X: ",redrobot.x,"\n")
end
