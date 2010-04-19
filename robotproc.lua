robotproc={}

for line in io.lines "proc.txt" do
  --only include non-blank lines
  if line ~= "" then robotproc[#robotproc+1]=string.upper(line) end
end

return robotproc
