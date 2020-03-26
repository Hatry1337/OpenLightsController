
-- Import libraries
local GUI = require("GUI")
local system = require("System")
local color = require("Color")
---------------------------------------------------------------------------------
local workspace, window, menu = system.addWindow(GUI.titledWindow(50, 22, 80, 30, "OpenLight Lamps Controller", true))
window.actionButtons.maximize:remove()
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))
local chosenLight = 1


local cbox = layout:addChild(GUI.comboBox(3, 2, 30, 3, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
local clrSelectr = layout:addChild(GUI.colorSelector(2, 2, 30, 3, 0xFF55FF, "Choose color"))


local function updateControls(index, lamps)
	local lamp = lamps[index]
	clrSelectr.color = tonumber("0x"..lamp.getColor())
end

local lights = {}
local counter = 1
for addr,name in component.list() do
  if name == "openlight" then
  	cbox:addItem("Light "..counter).onTouch = function()
  		updateControls(cbox.selectedItem, lights)
  		chosenLight = cbox.selectedItem
  	end
    table.insert(lights, component.proxy(addr))
    counter = counter+1
  end
end

clrSelectr.onColorSelected = function()
	local lamp = lights[chosenLight]
	lamp.setColor(clrSelectr.color)
end

local function tableLength(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end





workspace:draw()
