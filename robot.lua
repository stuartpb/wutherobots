proc=require "robotproc"
sensor={x=0}

robot={}
robot.instructions={
  LEFT=function(robot)
    robot.x=robot.x-1
  end,

  RIGHT=function(robot)
    robot.x=robot.x+1
  end,

  IFSENSORGOTO=function(robot,addr)
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

function robot:interpret()
  local command=select(3,
    string.find(
      proc[self.counter],
      "^([^ ]*) ?"))
  if command=="WAIT" then
    --do nothing
  elseif command=="LEFT" or command=="RIGHT" then
    robot.instructions[command](self)
  elseif command=="GOTO" or command=="IFSENSORGOTO" then
    local addr=select(3,
      string.find(
        proc[self.counter],
        " (%d+)"))
    if addr and tonumber(addr) then
      robot.instructions[command](self,tonumber(addr))
    else
      roboerror "Jump functions must include an address."
    end
  else
    roboerror(string.format(
      "%i: Invalid command %q.",
      self.counter,command))
  end
end

function robot:step()
  self.jumpedto=nil
  self.counter=self.counter+1
  if self.counter > #proc then
    roboerror (
      "End of instructions reached. You need to end with a GOTO.")
  else
    self:interpret()
  end
end

function robot:jump(addr)
  if addr > #proc then
    roboerror "Attempt to jump past the end of the list."
  elseif addr < 1 then
    roboerror "Attempt to jump past the beginning of the list."
  elseif addr == self.counter then
    roboerror "Attempt to jump to same address as command to jump."
  elseif self.jumpedto and self.jumpedto[addr] then
    roboerror(string.format("Infinite jump loop at %s.",addr))
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
    jump=robot.jump
  }
end

return robot
