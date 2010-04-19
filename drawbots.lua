local minwidth=15
local margin=2
local aspectratio=1 --initialized in case resize_cb isn't called first

function drawbots()
  local gap=math.abs(servo.x-crow.x)
  local left=math.min(servo.x,crow.x)

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

  --crow
  gl.Color(1,.8,0)
  gl.Rect(crow.x,-2,crow.x+1,0)

  --servo
  gl.Color(.8,0,0)
  gl.Rect(servo.x,-2,servo.x+1,0)
end

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

  self:action()
end

function canvas:action()
  iup.GLMakeCurrent(self)
  drawbots()
  iup.GLSwapBuffers(self)
  gl.Flush()
end
