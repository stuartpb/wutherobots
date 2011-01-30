local gl = require "luagl"

local robot = require "robot" --sensor
local sensor = robot.sensor

local minwidth=15
local margin=2
local aspectratio=1 --initialized in case resize_cb isn't called first

local gldriver={}

function gldriver.drawbots(heathcliff,catherine)
  local gap=math.abs(heathcliff.x-catherine.x)
  local left=math.min(heathcliff.x,catherine.x)

  if gap < minwidth then
    left=left-(minwidth-gap)/2
    gap=minwidth
  end

  local cleft=left-margin
  local cright=left+gap+margin

  local halfheight=(aspectratio*(gap+margin*2))/2

  gl.MatrixMode "PROJECTION"
  gl.LoadIdentity()
  gl.Ortho(cleft,cright,
    halfheight,-halfheight,
    -1,1)

  gl.ClearColor(.5,.5,.9,1)
  gl.Clear "COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT"

  gl.Color(0,.9,0)
  gl.Rect(cleft,0,cright,halfheight)

  --sensor light
  gl.Color(.625,.625,.925)
  gl.Rect(sensor.x+.2,-halfheight,sensor.x+.8,0)

  --sensor
  gl.Color(1,1,1)
  gl.Rect(sensor.x,-.125,sensor.x+1,0)

  --catherine
  gl.Color(1,.8,0)
  gl.Rect(catherine.x,-2,catherine.x+1,0)

  --heathcliff
  gl.Color(.8,0,0)
  gl.Rect(heathcliff.x,-2,heathcliff.x+1,0)

  --red flowers
  for x=cleft-cleft%9, cright,9 do
    local y=2+(x%18/9)*2
    gl.Color(1,0,.3)
    gl.Rect(x,y,x+1,y+1)

    gl.Color(1,.8,0)
    gl.Rect(x+1/3,y+1/3,x+2/3,y+2/3)
  end

  --blue flowers
  for x=cleft-cleft%16, cright,16 do
    local y=1+(x%48/16)*2
    gl.Color(0,.3,1)
    gl.Rect(x,y,x+1,y+1)

    gl.Color(1,.8,0)
    gl.Rect(x+1/3,y+1/3,x+2/3,y+2/3)
  end
  gl.Flush()
end

function gldriver.register_resize_cb(canvas)
  function canvas:resize_cb(width, height)
    --gl.Viewport defines the region of the canvas to draw to
    --so set it to the entirety of the new canvas size
    gl.Viewport(0, 0, width, height)

    --if you resize the window to its smallest
    --then height can be 0 which would cause
    --divide by 0 errors so if that happens
    if height == 0 then
      --pretend it's not 0
      height = 1
    end

    --calculate aspect ratio
    aspectratio = height/width

    --redraw
    self:action()
  end
end

return gldriver
