require "iuplua"
require "iupluagl"
require "luagl"

maxdistance=100

canvas = iup.glcanvas{buffer="DOUBLE", rastersize="640x480", border="NO"}

dialog = iup.dialog{canvas; title="WE ARE TEH R0B0TS"}

function roboerror(msg)
  loop.run="NO"
  iup.Message("ROBO ERROR",msg)
  iup.ExitLoop()
end

require "robot"

math.randomseed(os.time())

--introduce entropy
math.random() math.random()

servo= robot.new(-math.random(maxdistance))
crow= robot.new(math.random(maxdistance))

loop=iup.timer{time="50",
  action_cb=function(self)
    crow:step()
    servo:step()
    canvas:action()
    dialog.title=string.format(
      "Bot 1 X: %i Bot 2 X: %i",
      crow.x,servo.x)
    if (crow.x==servo.x) then
      return iup.CLOSE
    end
  end,
  run="NO"
}

require "drawbots"

dialog:show()

loop.run="YES"

iup.MainLoop()
