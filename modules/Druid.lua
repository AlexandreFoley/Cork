
local myname, Cork = ...
if Cork.MYCLASS ~= "DRUID" then return end

if Cork.WoWClassic then
	--thorns
	local spellname, _, icon, _, _, _, spellid = GetSpellInfo(467)
	local dataobj = Cork:GenerateSelfBuffer(spellname, icon, spellid)
	--mark of the wild --will replace with raid buffer.
	local spellname, _, icon, _, _, _, spellid = GetSpellInfo(1126)
	local dataobj = Cork:GenerateSelfBuffer(spellname, icon, spellid)

else

-- Shapeshifts
local dobj, ref = Cork:GenerateAdvancedSelfBuffer("Fursuit", {768, 5487, 24858})
function dobj:CorkIt(frame)
	ref()
	local spell = Cork.dbpc["Fursuit-spell"]
	if self.player and Corkboard:NumLines() == 1 then
		return frame:SetManyAttributes("type1", "spell", "spell", spell, "unit", "player")
	end
end

end