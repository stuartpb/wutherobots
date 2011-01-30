local iup = require "iuplua"
            require "iupluagl"

local robot = require "robot"
local gldriver = require "gldriver"

local maxdistance=100

local canvas = iup.glcanvas{buffer="DOUBLE", rastersize="640x480", border="NO"}
local dialog = iup.dialog{canvas; shrink="YES"}

robot.register_error_handler(function (msg)
  loop.run="NO"
  iup.Message("ROBO ERROR",msg)
  iup.ExitLoop()
end)

math.randomseed(os.time())

--introduce entropy
math.random() math.random()

local heathcliff= robot.new(-math.random(maxdistance))
local catherine= robot.new(math.random(maxdistance))

gldriver.register_resize_cb(canvas,heathcliff,catherine)

function canvas:action()
  iup.GLMakeCurrent(self)
  gldriver.drawbots(heathcliff,catherine)
  iup.GLSwapBuffers(self)
end

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

dialog:show()

loop.run="YES"

iup.MainLoop()
