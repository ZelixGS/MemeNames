default_items = {
	[1]="Addon Loading Bool", -- Used to Check if Addon has loaded defaults before, not an actual item ID.
	
	--[<Item ID>]="<New Name>", -- Old Item Name
	--Test Items
	[39398]="Massive Cupsholder", 						-- Massive Skeletal Ribage
	[39399]="Helm of Testing", 							-- Helm of the Vast Legions

	--The Burning Crusader
	[32757]="Medallion of the Tryhard Crusader", 		-- Blessed Medallion of Karabor
	
	--Warlords of Draenor
	[109997]="Injector of Bombing Mk2",					-- Kihra's Adrenaline Injector
	[110017]="Ambassador Pineapple", 					-- Enforcer's Stun Grenade

	--Legion
	[134542]="Forever Relevant :(",						-- Jeweled Signet of Melandrus
	[137537]="Sleeper Tank Trinket",					-- Tirathon's Betrayal
	[137539]="Icyhot",									-- Faulty Countermeasure
	[137541]="Moonlit Middlefinger",					-- Moonlit Prism
	
	
	--Shadowlands
	[172051]="Steak and Mash", 							-- Steak a la Mode
	[178708]="Hedgehog of Dubious Speed", 				-- Unbound Changeling
	[178715]="Doot Doot", 								-- Mistcaller Ocarina
	[178771]="Granny Plague's Bathwater", 				-- Phial of Putrefaction
	[178810]="Blue Gatorade", 							-- Vial of Spectral Essence
	[179331]="God-Shattering Scale", 					-- Blood-Splattered Scale
	[179350]="Cube of Mana Restoration", 				-- Inscrutable Quantum Device
	[181501]="Candle of Protagonist Power",				-- Flame of Battle
	[181502]="Green Gatorade",							-- Rejuvenating Serum
	[182335]="De Wild Spirits",							-- Spirit Attunement (Conduit)
	[182448]="Long Horse", 								-- Light's Barding (Conduit)
	[182464]="Turtle Club",								-- Harmony of the Tortollen (Conduit)
	[183034]="Cloakwing's Only Loot", 					-- Cowled Batwing Cloak
	[183035]="I-Buy-PvP-Power Signet", 					-- Arden Sunstar Signet
	[183894]="Red Marble of a Dissappointing Offhand", 	-- Thaumaturgic Anima Bead
	[184018]="Splintered Heart of Social Distancing",	-- Splinter of Al'ar
	[184019]="Essence of Tacobell",						-- Soul Igniter
	[184020]="Phoenix Down", 							-- Tuft of Smoldering Plumage
	[184024]={"Art Degree", "Toilet Paper"},			-- Macabre Sheet Music (First Random Item! 3/10/21)
	[184026]="Ozma's Keelhauling Chain", 				-- Hateful Chain
	[184031]={"Get you some Sip", "Cum Chalice"},		-- Sanguine Vintage (Named by Kalcifur)
	[184840]="Book of Blasting Mk2", 					-- Hymnal of the Path
	[184842]="Bell of Bombing", 						-- Instructor's Divine Bell
	
	-- 9.1 Items
	--[186423]={"Worthy Eye of the Raidleader", "Unworthy Eye of the Raidleader"},		-- Titanic Ocular Gland
	[186424]="Shard of Analhyde's Assgis",				-- Shard of Annhylde's Aegis
	[186428]="Ponderous Orb of Torment",				-- Shadowed Orb of Torment
	[186433]="Thorncoat", 								-- Reactive Defense Matrix
	[187542]="Ozmthys, the Devouring Blade",			-- Jaithys, The Prison Blade
	[186410]="Ozmthys, the Devouring Blade",			-- Jaithys, The Prison Blade (Again)
	[186398]="Edge of Viability", 						-- Edge of Night
	[186414]="Some bit of garbage",						-- Rae'shalare, Death's Whisper
	[186438]="Orc yelling 'KEEP PULLING'",				-- Old Warrior's Soul		
	[185783]="The REAL Legendary Bow",					-- Yasahm the Riftbreaker
	[185818]="So'leah's Simping Technique", 			-- So'leah's Secret Technique
	[185836]="Book of Blocking Mk12",					-- Codex of the First Technique
	[190958]="So'leah's Simping Technique", 			-- So'leah's Secret Technique(There is 2 instances of this Item for Some Reason)

	-- 9.2 Items
	[188267]="Levithan's Lure Mk-2",					-- Bells of the Endless Feast
	[188265]="Cache of No Axes?",						-- Cache of Acquired Treasures
	[188266]="Ant-Squishing Riftshard",					-- Pulsating Riftshard
	[188272]="Healer Trinket",							-- Resonant
	[188270]="Elegy of the Cucked DPS",					-- Elegy of the Eternals
	[188271]="Horn of Valor Mk2", 						-- The First Sigil
	[188264]="Shakerpage", 								-- Earthbreaker's Impact
	[188255]="NOT THE BEEEEEEEEES",						-- Heart of the Swarm
}



-- Used to Hold Table Information for Session and Random Names.
items = {}
ran_names = {}


-- Script Variables
giga_level = 278 -- Used to determine when something is max ilvl. Typically Mythic Raid ilvl.
giga_name = "Giga"
mega_level = 272
mega_name = "Mega"


--[[
	We Enter this Function under the assumption we already know 100% the ID has a new name.
	First Determine if it's a Single Item, or Random.
	If it's Random, we check our ran_names table to see if a value has been generated. If not, we Generate One.
	Secondly, If we hold down the Alt Key, we add the Real Name in Parenthesis.
	--]]
local function GetNewName(id, fromChat)
		local name
		if type(items[id]) == "string" then 
		name = items[id] 
	end
	if type(items[id]) == "table" then
		if ran_names[id] == nil then
			ran_names[id] = math.random(1, #items[id])
		end
		name = items[id][ran_names[id]]
	end
	if IsAltKeyDown() and not fromChat then
		local OldName = C_Item.GetItemNameByID(id)
		name = name.."\n("..OldName..")"
	end
	return name
end

local function isGiga(ilvl)
	if ilvl == nil then
		return nil
	end
	if ilvl >= giga_level then
		return giga_name.." "
	elseif ilvl == mega_level then 
		return mega_name.." "
	end
	return nil
end

-- Helper Function to get IDs from ItemLinks
local function GetIDFromLink(msg)
	local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, reforging, Name = string.find(msg, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return tonumber(Id)
end

--[[
	Function to Modify tooltips, tooltips should contain information allowing us to get/set information, index is used to know which tooltip to modify.
	First we get a link to the item and filter out the item id, we then match it to the items array and if that spot isn't empty we know we have a match.
	We double check if the tooltip has a title, then we replace the name with our own.
	Lastly we display it.
--]]
local function ModTooltip(tooltip, index)
	local link = select(2, tooltip:GetItem())
	if link == nil then return end

	local itemID = tonumber(string.match(link, "item:(%d*)"))
	if itemID ~= nil then
		local ilvl = select(4, GetItemInfo(select(2, tooltip:GetItem())))
		local NewName = C_Item.GetItemNameByID(itemID)
		local Prefix = isGiga(ilvl)
		if items[itemID] ~= nil then
			NewName = GetNewName(itemID, false)
		end
		if Prefix ~= nil then
			NewName = Prefix..NewName
		end
		local tooltipTitle = _G[tooltip:GetName() .. "TextLeft" .. index]
		if tooltipTitle then
			tooltipTitle:SetJustifyH("LEFT")
			tooltipTitle:SetText(NewName)
		end
		tooltip:Show()
	end
end

--Hooks to ModTooltip, we pass an Index to know which Tooltip to Modify (In the Case of Comparison Tooltips).
GameTooltip:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 1); end)
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 1); end)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 2); end)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 2); end)
--ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 2); end)
--ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 2); end)
GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 1); end)

--[[
	Used to Modify the Encounter Journal's Items.
	Runs each time the Frame Update is called (New Encounter, Zone, Scrolled etc)
	Scans for Item ID through Links, then renames the Items if any name exsists.
	Lastly, we wrap the new name in the item quaility's color as the Encounter Journal doesn't do that automatically.
--]]

local function EncounterJournalFrame(self)
    local id = self.itemID
	if items[id] ~= nil then
		local NewName = GetNewName(id, false)
		local Quality = C_Item.GetItemQualityByID(self.link)
		local Color = ITEM_QUALITY_COLORS[Quality].hex

		if Quality ~= nil then
			if id == 186414 then --Rae'shalare, Death's Whisper
				Color = ITEM_QUALITY_COLORS[0].hex
				self.lootFrame.IconBorder:SetVertexColor(0.6, 0.6, 0.6, 0.5)
			end

			if id == 185783 then --Yasahm the Riftbreaker
				Color = ITEM_QUALITY_COLORS[5].hex
				self.lootFrame.IconBorder:SetVertexColor(1, 0.5, 0, 0.5)
			end
		end
		self.lootFrame.name:SetText(Color..NewName)
	end
end


--[[
	To Modify Chat Hyper Links, we first pass in a object, event, and message. 
	First start by looping through the string and finding all instances of "|Hitem:", we parse the item ID with a snippet from WoWPedia: https://wow.gamepedia.com/ItemLink
	Add the Id as an integer to the tables "links".
	Next loop through all instances of item links and check the ids to our items table, if a result is found we modify msg2 with the name replacement.
	Lastly return msg2.
--]]
local function ModChat(self, event, msg, ...)
	local links = {}	-- table to store the indices
	local i = 0
	while true do
		i = string.find(msg, "|Hitem:", i+1)    -- find 'next' newline
		if i == nil then break end
		local chatitem = string.match(msg, "item[%-?%d:]+", i)
		table.insert(links, chatitem)
	end
	
	local msg2 = msg
	for j, v in ipairs(links) do
		local id = GetIDFromLink(v)
		local NewName = C_Item.GetItemNameByID(id)
		local Prefix = isGiga(GetDetailedItemLevelInfo(v))

		if items[id] ~= nil then
			NewName = GetNewName(id, true)
		end

		if Prefix ~= nil then
			NewName = Prefix..NewName
		end

		msg2 = gsub(msg2, C_Item.GetItemNameByID(id), NewName)
	end
	return false, msg2, ...
end


--Chat Hooks
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER",ModChat)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT",ModChat)





--[[
	Used to Handle Chat Functionality, Renaming, Adding, Removing, Reset, and Re-Randomizing names.
	Currently is a mess, might rewrite eventually? But it works.
--]]
-- SLASH_MEMENAME1 = '/mn'
-- function SlashCmdList.MEMENAME(msg, editBox)
-- 	if string.find(string.upper(msg), "-HELP") then
-- 		print("MemeNames: To Add a Name, Link an Item and type it's new name afterwards.")
-- 		print("MemeNames: To Remove a Name, Link Item and Type '-clear' afterwards.")
-- 		return
-- 	end
-- 	if string.find(string.upper(msg), "-RANDOM") then
-- 		print("MemeNames: Re-Randomizing Items")
-- 		ran_names = {}
-- 		return
-- 	end
--     if string.find(msg, "|Hitem:") then
-- 		local ID = GetIDFromLink(msg)
-- 		local NewName = string.match(msg, "|r (.*)") --Unholy Regex/Pattern Matching
-- 		local OldName = C_Item.GetItemNameByID(ID)
-- 		if NewName == nil then
-- 			print("MemeNames: Error, No Name Found!")
-- 			return
-- 		elseif string.upper(NewName) == "-CLEAR" then
-- 			print("MemeNames: Removed "..OldName.."'s Meme Name!")
-- 			items[ID] = nil
-- 		elseif string.upper(NewName) == "-RESET" then
-- 			if default_items[ID] == nil then 
-- 				print("MemeNames: "..OldName.." has no default Name.")
-- 				return
-- 			end
-- 			items[ID] = default_items[ID]
-- 			print("MemeNames: Restoring "..OldName.." to "..items[ID].."")
-- 		elseif items[ID] ~= nil then
-- 			if type(items[ID]) == "string" then
-- 				temp = items[ID]
-- 				items[ID] = { temp, NewName}
-- 			else
-- 				table.insert(items[ID], NewName)
-- 			end
-- 			print("MemeNames: Added "..NewName.." as possibility for "..OldName.."")
-- 		else
-- 			print("MemeNames: Renamed "..OldName.." to "..NewName.."")
-- 			items[ID] = NewName
-- 		end
-- 	else
-- 		print("MemeName: Error, Missing Item Link!")
-- 	end
-- end


--[[
	Used on Startup to Catch Addon Loading.
	If we just loaded ourselves and our sentinal value isn't loaded we know that we haven't saved any variables.
	So we just write the Default Table to the Items table.concat
	
	If the EncounterJournal is loaded we hook a function to allow us to update names in the Encounter Journal.
--]]
local f = CreateFrame("Frame");
function f:EventHandler(event, arg1, ...)
	if event == "ADDON_LOADED" then
		if arg1 == "MemeNames" then
			--if items[1] == nil then
				items = default_items
			--end
		end
		if arg1 == "Blizzard_EncounterJournal" then
			hooksecurefunc("EncounterJournal_SetLootButton", EncounterJournalFrame)
		end
	end
end
f:SetScript("OnEvent",f.EventHandler);
f:RegisterEvent("ADDON_LOADED");

