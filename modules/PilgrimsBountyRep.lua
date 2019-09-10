
local myname, ns = ...
local ae = LibStub("AceEvent-3.0")

local WoWClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
if not WoWClassic then

local maxlevel = GetMaxPlayerLevel()
local itemname = "Pilgrim's Bounty Rep Buff"
local spellname, _, icon = GetSpellInfo(61849)
local dataobj = ns:GenerateSelfBuffer(itemname, icon, spellname)
ns.defaultspc[itemname.."-enabled"] = true


local function BountyToday()
	return ns.IsHolidayActive("Pilgrim's Bounty")
end


function dataobj:Test()
	if UnitLevel("player") < maxlevel then return false end
	return BountyToday() and self:TestWithoutResting()
end


function dataobj:Init()
	if UnitLevel("player") == maxlevel then OpenCalendar() end
end


ae.RegisterEvent(dataobj, "CALENDAR_UPDATE_EVENT_LIST", "Scan")
dataobj.tiplink = "spell:61849"
dataobj.CorkIt = nil
end