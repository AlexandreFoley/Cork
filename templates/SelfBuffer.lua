
local myname, Cork = ...
local UnitAura = Cork.UnitAura or UnitAura
local ldb, ae = LibStub:GetLibrary("LibDataBroker-1.1"), LibStub("AceEvent-3.0")

local function HasBuff(spells)
	if Cork.WoWClassic then
		for _,spell in pairs(spells) do
			local Abuff = "takesomeroom"
			local index = 1
			while Abuff and index <=40 do
				Abuff = UnitAura("player",index,"PLAYER")
				if Abuff == spell then return true end
				index = index + 1
			end
		end
	else
		for _,spell in pairs(spells) do
			if UnitAura("player", spell) then return true end
		end
	end
end

local function CheckCooldown(self)
	if not self.checkcooldown then return true end

	local start, duration = GetSpellCooldown(self.spellname)
	if duration and start then
		if (start == 0 or duration <= 1.5) then return true end

		Cork.StartTimer(start + duration, self.Scan)
	end
	return false
end

local function Init(self)
	local name = GetSpellInfo(self.spellname)
	Cork.defaultspc[self.spellname.."-enabled"] = name ~= nil
end

local function TestWithoutResting(self)
	if Cork.dbpc[self.spellname.."-enabled"] and not HasBuff(self.spells) and CheckCooldown(self) then
		return self.iconline
	end
end

local function Test(self)
	return not (IsResting() and not Cork.db.debug) and self:TestWithoutResting()
end

local function CorkIt(self, frame)
	if self.player then
		return frame:SetManyAttributes("type1", "spell", "spell", self.spellname,
			"unit", "player")
	end
end

local function UNIT_AURA(self, event, unit)
	if unit == "player" then self:Scan() end
end


function Cork:GenerateSelfBuffer(spellname, icon, spellid, ...)
	if not spellid then 
		spellid = GetSpellLink(spellname)
	else
		spellid = "spell:"..spellid
	end
	local dataobj = ldb:NewDataObject("Cork "..spellname, {
		type      = "cork",
		corktype  = "buff",
		tiplink   = spellid,
		iconline  = self.IconLine(icon, spellname),
		spells    = {spellname, ...},
		spellname = spellname,
		Init      = Init,
		Test      = Test,
		CorkIt    = CorkIt,
		UNIT_AURA = UNIT_AURA,
		TestWithoutResting = TestWithoutResting,
		HasBuff = HasBuff,
	})

	function dataobj.Scan()
		dataobj.player = dataobj:Test()
	end

	ae.RegisterEvent(dataobj, "UNIT_AURA")
	ae.RegisterEvent(dataobj, "PLAYER_UPDATE_RESTING", "Scan")

	return dataobj
end
