local ArgbOutput = {
  name = 'ARGB',
}

function ArgbOutput.str(RGB, A)
  local R = math.floor(RGB[1] * 255 + 0.5)
  local G = math.floor(RGB[2] * 255 + 0.5)
  local B = math.floor(RGB[3] * 255 + 0.5)
  if A then
    local a = math.floor(A * 255 + 0.5)
    return ('0x%02x%02x%02x%02x'):format(a, R, G, B)
  else
    return ('0xff%02x%02x%02x'):format(R, G, B)
  end
end

return ArgbOutput
