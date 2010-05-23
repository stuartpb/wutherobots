require "iuplua"
require "iupluagl"
require "luagl"

maxdistance=100

canvas = iup.glcanvas{buffer="DOUBLE", rastersize="640x480", border="NO"}

dialog = iup.dialog{canvas; shrink="YES"}

function roboerror(msg)
  loop.run="NO"
  iup.Message("ROBO ERROR",msg)
  iup.ExitLoop()
end

require "robot"

math.randomseed(os.time())

--introduce entropy
math.random() math.random()

heathcliff= robot.new(-math.random(maxdistance))
catherine= robot.new(math.random(maxdistance))

loop=iup.timer{time="50",
  action_cb=function(self)
    catherine:step()
    heathcliff:step()
    canvas:action()
    dialog.title=string.format(
      "Catherine: %i Heathcliff: %i",
      catherine.x,heathcliff.x)
    if (catherine.x==heathcliff.x) then
      return iup.CLOSE
    end
  end,
  run="NO"
}

require "drawbots"

dialog:show()

loop.run="YES"

iup.MainLoop()
