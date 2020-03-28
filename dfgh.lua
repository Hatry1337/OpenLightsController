local component = require("component")
local event = require("Event")
local mathFloor, mathModf = math.floor, math.modf

local lights = {}
for addr,name in component.list() do
  if name == "openlight" then
    table.insert(lights, component.proxy(addr))
  end
end

local function HSBToRGB(h, s, b)
  local integer, fractional = mathModf(h / 60)  
  local p, q, t = b * (1 - s), b * (1 - s * fractional), b * (1 - (1 - fractional) * s)

  if integer == 0 then
    return mathFloor(b * 255), mathFloor(t * 255), mathFloor(p * 255)
  elseif integer == 1 then
    return mathFloor(q * 255), mathFloor(b * 255), mathFloor(p * 255)
  elseif integer == 2 then
    return mathFloor(p * 255), mathFloor(b * 255), mathFloor(t * 255)
  elseif integer == 3 then
    return mathFloor(p * 255), mathFloor(q * 255), mathFloor(b * 255)
  elseif integer == 4 then
    return mathFloor(t * 255), mathFloor(p * 255), mathFloor(b * 255)
  else
    return mathFloor(b * 255), mathFloor(p * 255), mathFloor(q * 255)
  end
end
function RGBToInteger(r, g, b)
        return r * 65536 + g * 256 + b
end

local a, b =  pcall(function()
  lampCtrl.rgb.counter = lampCtrl.rgb.counter
end)
if not a then
  lampCtrl = {
    ["rgb"] = {
      ["counter"] = 0,
      ["freq"] = 5
    }
  }
end
lampCtrl["handler"] = event.addHandler(function()
  for i,lamp in ipairs(lights) do
    lamp.setBrightness(10)
    lamp.setColor(RGBToInteger(HSBToRGB( lampCtrl.rgb.counter * lampCtrl.rgb.freq % 360, 1, 1 )))
  end
  lampCtrl.rgb.counter = lampCtrl.rgb.counter+1
end, 0.1)

