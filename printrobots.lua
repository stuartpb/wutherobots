maxdistance=100

function roboerror(msg)
  error(msg)
end

require "robot"

math.randomseed(os.time())
badrobot= robot.new(math.random(maxdistance))
redrobot= robot.new(-math.random(maxdistance))

io.write("Bot 1 X: ",badrobot.x,"\tBot 2 X: ",redrobot.x,"\n")
while badrobot.x~=redrobot.x do
  badrobot:step()
  redrobot:step()
  io.write("Bot 1 X: ",badrobot.x,"\tBot 2 X: ",redrobot.x,"\n")
end
