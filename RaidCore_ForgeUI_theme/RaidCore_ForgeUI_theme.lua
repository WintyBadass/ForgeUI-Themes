-----------------------------------------------------------------------------------------------
-- 
-- ForgeUI theme for RaidCore
-- 
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- RaidCore_ForgeUI_theme Module Definition
-----------------------------------------------------------------------------------------------
local RaidCore_ForgeUI_theme = {}
local RaidCore_ForgeUI_themeInst

local ForgeUI
local RaidCore 

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
 
-----------------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------------
local fnNewBar
local fnNewBarOrig
local fnSetBGColor
local fnSetBGColorOrig
local fnSetBarColor
local fnSetBarColorOrig

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function RaidCore_ForgeUI_theme:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    return o
end

function RaidCore_ForgeUI_theme:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		"RaidCore", "ForgeUI"
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end

-----------------------------------------------------------------------------------------------
-- RaidCore_ForgeUI_theme OnLoad
-----------------------------------------------------------------------------------------------
function RaidCore_ForgeUI_theme:OnLoad()
	ForgeUI = Apollo.GetAddon("ForgeUI")
	RaidCore = Apollo.GetAddon("RaidCore")
	if not ForgeUI or not RaidCore then return end
	
	self.xmlDoc = XmlDoc.CreateFromFile("RaidCore_ForgeUI_theme.xml")
	self.xmlDoc:RegisterCallback("CreateHooks", self)	
end

function RaidCore_ForgeUI_theme:CreateHooks()
	fnNewBarOrig = _G["RaidCoreLibs"]["DisplayBar"].new
	_G["RaidCoreLibs"]["DisplayBar"].new = fnNewBar
	
	fnSetBarColorOrig = _G["RaidCoreLibs"]["DisplayBar"].SetBarColor
	_G["RaidCoreLibs"]["DisplayBar"].SetBarColor = fnSetBarColor
	
	fnSetBGColorOrig = _G["RaidCoreLibs"]["DisplayBar"].SetBGColor
	_G["RaidCoreLibs"]["DisplayBar"].SetBGColor = fnSetBGColor
end

-----------------------------------------------------------------------------------------------
-- Hooks
-----------------------------------------------------------------------------------------------
fnNewBar = function(xmlDoc, key, message, maxTime, type, block)
	local self = fnNewBarOrig(xmlDoc, key, message, maxTime, type, block)
	
	self.Frame:FindChild("Text"):SetFont("Nameplates")
	self.Frame:FindChild("Timer"):SetFont("Nameplates")
	
	if type < 3 then
		self.Frame:SetSprite("")
		self.Border = Apollo.LoadForm(RaidCore_ForgeUI_themeInst.xmlDoc, "BarBorder", self.Frame, self)
		
		self.Frame:FindChild("RemainingOverlay"):SetAnchorOffsets(1, 4, -1, -1)
		self.Frame:FindChild("RemainingOverlay"):SetFullSprite("ForgeUI_Bar")
		self.Frame:FindChild("RemainingOverlay"):SetSprite("ForgeUI_Bar")
		self.Frame:FindChild("RemainingOverlay"):SetBarColor("FF272727")
		self.Frame:FindChild("RemainingOverlay"):SetBGColor("FF101010")
		self.Frame:FindChild("RemainingOverlay"):SetStyle("Picture", true)
		
		self.Frame:FindChild("Text"):SetAnchorOffsets(33, 3, 0, 0)
		self.Frame:FindChild("Timer"):SetAnchorOffsets(50, 3, -10, 0)
		
		self.Frame:FindChild("Mark"):SetAnchorPoints(0, 0, 0, 1)
		self.Frame:FindChild("Mark"):SetAnchorOffsets(0, 3, 35, 0)
		self.Frame:FindChild("Mark"):SetFont("Nameplates")
	end
	
	return self
end

fnSetBarColor = function(luaCaller, color)
	luaCaller.Frame:FindChild("RemainingOverlay"):SetBarColor("FF272727")
	fnSetBarColorOrig(luaCaller, color)
end

fnSetBGColor = function(luaCaller, color)
	luaCaller.Frame:SetBGColor("FF000000")
	--fnSetBGColorOrig(luaCaller, color)
end

-----------------------------------------------------------------------------------------------
-- RaidCore_ForgeUI_theme Instance
-----------------------------------------------------------------------------------------------
RaidCore_ForgeUI_themeInst = RaidCore_ForgeUI_theme:new()
RaidCore_ForgeUI_themeInst:Init()
