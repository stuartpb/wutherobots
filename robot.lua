local proc=dofile "robotproc.lua"

local robot={sensor={x=0}}
local sensor=robot.sensor

local roboerror
--module functions
function robot.register_error_handler(handler)
  roboerror = handler
end

--robot functions
robot.instructions={
  LEFT=function(robot)
    robot.x=robot.x-1
  end,

  RIGHT=function(robot)
    robot.x=robot.x+1
  end,

  SWITCH=function(robot,addr)
    if robot.x==sensor.x then
      robot:jump(addr)
    else
      robot:step()
    end
  end,

  GOTO=function(robot,addr)
    robot:jump(addr)
  end,
}

function robot:error(...)
  roboerror(string.format(
    "%i (%s): %s",
    self.counter, proc[self.counter],
    string.format(...)))
end

function robot:interpret()
  local command=select(3,
    string.find(
      proc[self.counter],
      "^([^ ]*) ?"))
  if command=="WAIT" then
    --do nothing
  elseif command=="LEFT" or command=="RIGHT" then
    robot.instructions[command](self)
  elseif command=="GOTO" or command=="SWITCH" then
    local addr=select(3,
      string.find(
        proc[self.counter],
        " (%d+)"))
    if addr then
      if tonumber(addr) then
        robot.instructions[command](self,tonumber(addr))
      else
        self:error('"%s" is not a valid address.',addr)
      end
    else
      self:error "Jump functions must include an address."
    end
  else
    self:error('Invalid command "%s".',command)
  end
end

function robot:step()
  self.jumpedto = nil
  self.counter = self.counter+1
  if self.counter > #proc then
    self:error (
      "End of instructions reached. You need to end with a GOTO.")
  else
    self:interpret()
  end
end

function robot:jump(addr)
  if addr > #proc then
    self:error(
      "Attempt to jump past the end of the list."..
      " (%i commands, jump was to %i)", #proc,addr)
  elseif addr < 1 then
    self:error(
      "Attempt to jump past the beginning of the list."..
      " (commands start at 1, %i is less than 1)",addr)
  elseif addr == self.counter then
    self:error "Attempt to jump to same address as command to jump."
  elseif self.jumpedto and self.jumpedto[addr] then
    self:error ("Jumping to %s enters an infinite jump loop.",addr)
  else
    self.counter=addr
    self.jumpedto=self.jumpedto or {}
    self.jumpedto[addr]=true
    self:interpret()
  end
end

function robot.new(position)
  return {
    counter=0, --designed to be stepped into
    x=position,
    interpret=robot.interpret,
    step=robot.step,
    jump=robot.jump,
    error=robot.error
  }
end

return robot
