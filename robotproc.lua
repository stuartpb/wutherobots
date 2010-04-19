robotproc={}

for line in io.lines "proc.txt" do
  --only include non-blank lines
  if line ~= "" then robotproc[#robotproc+1]=line end
end

return robotproc
