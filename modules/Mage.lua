
local myname, Cork = ...
if Cork.MYCLASS ~= "MAGE" then return end



if Cork.WoWClassic then

	-- Ice Barrier
	local spellname, _, icon, _, _, _, spellid = GetSpellInfo(11426)
	local dataobj = Cork:GenerateSelfBuffer(spellname, icon,spellid)
	dataobj.checkcooldown = true

	-- Frost Armor
	local spellname, _, icon, _, _, _, spellid = GetSpellInfo(7300)
	local dataobj = Cork:GenerateSelfBuffer(spellname, icon, spellid)

	-- Arcane Intellect --will replace with raid buffer.
	local spellname, _, icon, _, _, _, spellid = GetSpellInfo(1460)
	local dataobj = Cork:GenerateSelfBuffer(spellname, icon, spellid)

else

-- Ice Barrier
local spellname, _, icon = GetSpellInfo(11426)
local dataobj = Cork:GenerateSelfBuffer(spellname, icon)
dataobj.checkcooldown = true

-- Water Elemental (frost pet)
local spellname, _, icon = GetSpellInfo(31687)
local iconline = Cork.IconLine(icon, spellname)
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")
local UnitAura = Cork.UnitAura or UnitAura

local function Init(self)
	local name = GetSpellInfo(spellname)
	Cork.defaultspc[spellname.."-enabled"] = name ~= nil
end

local function TestWithoutResting()
	if Cork.dbpc[spellname.."-enabled"] and not UnitExists('pet') then
		return iconline
	end
end

local function Test()
	return not (IsResting() and not Cork.db.debug) and TestWithoutResting()
end

local function Scan(self, ...) self.player = Test() end

local function CorkIt(self, frame)
	if self.player then
		return frame:SetManyAttributes("type1", "spell", "spell", spellname,
			"unit", "player")
	end
end

local function UNIT_PET(self, event, unit)
	if unit == "player" then self:Scan() end
end


local dataobj = ldb:NewDataObject("Cork "..spellname, {
	type      = "cork",
	tiplink   = GetSpellLink(spellname),
	Init      = Init,
	Scan      = Scan,
	CorkIt    = CorkIt,
	UNIT_PET  = UNIT_PET,
})

ae.RegisterEvent(dataobj, "UNIT_PET")
ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")
end
