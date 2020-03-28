
-- Import libraries
local GUI = require("GUI")
local system = require("System")
local color = require("Color")
---------------------------------------------------------------------------------
local workspace, window, menu = system.addWindow(GUI.titledWindow(50, 22, 80, 30, "OpenLight Lamps Controller", true))
window:addChild(GUI.panel(1, 2, window.width, window.height-1, 0x262626))
window.actionButtons.maximize:remove()
local localization = system.getCurrentScriptLocalization()
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

local cbox = layout:addChild(GUI.comboBox(3, 2, 30, 3, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
local clrSelectr = layout:addChild(GUI.colorSelector(2, 2, 30, 3, 0xFF55FF, "Choose color"))
local reloadLightsBtn = GUI.button(2, 6, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Disabled button")
local switch = layout:addChild(GUI.switch(3, 2, 8, 0x66DB80, 0x1D1D1D, 0xEEEEEE, false))

local chosenLight = 1
local lights = {}


local function loadLights()
	lights = {}
	for addr,name in component.list() do
	  if name == "openlight" then
	    table.insert(lights, component.proxy(addr))
	  end
	end
end

local function tableLength(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

local function updateControls()
	if(switch.state) then
		cbox.disabled = true
	else
		cbox.disabled = false
		local lamp = lights[chosenLight]
		clrSelectr.color = tonumber("0x"..lamp.getColor())
	end
end

local function setAllLampsColor(lamps, color, brightness)
	for _, lamp in ipairs(lamps) do
		lamp.setBrightness(brightness)
		lamp.setColor(color)
	end
end

local function updateCBox()
	cbox:clear()
	for i, item in ipairs(lights) do
		cbox:addItem("Light "..i).onTouch = function()
		  	updateControls()
		  	chosenLight = cbox.selectedItem
		end
	end
end


reloadLightsBtn.onTouch = function()
	loadLights()
	updateCBox(lights)
end

switch.onStateChanged = function()
	updateControls()
end

clrSelectr.onColorSelected = function()
	if(switch.state) then
		setAllLampsColor(lights, clrSelectr.color, 10)
	else
		local lamp = lights[chosenLight]
		lamp.setColor(clrSelectr.color)
	end
end


loadLights()
updateCBox()
updateControls()




workspace:draw()
