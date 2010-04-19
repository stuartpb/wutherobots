require "iuplua"
require "iupluagl"
require "luagl"

function roboerror(msg)
  iup.Message("ROBO ERROR",msg)
  iup.ExitLoop()
end

maxdistance=100

canvas = iup.glcanvas{buffer="DOUBLE", rastersize="640x480", border="NO"}

dialog = iup.dialog{canvas; title="WE ARE TEH R0B0TS"}

local function roboerror(msg)
  iup.Message("ROBO ERROR",msg)
  iup.ExitLoop()
end

require "robot"

math.randomseed(os.time())
servo= robot.new(-math.random(maxdistance))
crow= robot.new(math.random(maxdistance))

iup.timer{time="250",
  action_cb=function(self)
    crow:step()
    servo:step()
    recalculate()
    canvas:action()
    dialog.title=string.format(
      "Bot 1 X: %i Bot 2 X: %i",
      crow.x,servo.x)
    if (crow.x==servo.x) then
      return iup.CLOSE
    end
  end,
  run="YES"
}

require "drawbots"

dialog:show()


iup.MainLoop()
