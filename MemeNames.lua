default_items = {
	[1]="Addon Loading Bool", -- Used to Check if Addon has loaded defaults before, not an actual item ID.
	
	--[<Item ID>]="<New Name>", -- Old Item Name
	--Test Items
	[39398]="Massive Cupsholder", 						-- Massive Skeletal Ribage
	[39399]="Helm of Testing", 							-- Helm of the Vast Legions
	
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
	--[184031]="Get you some Sip", 						-- Sanguine Vintage (Named by Kalcifur)
	[184031]="Cum Chalice", 							-- Sanguine Vintage (Alternate Name)
	[184840]="Book of Blasting Mk2", 					-- Hymnal of the Path
	[184842]="Bell of Bombing", 						-- Instructor's Divine Bell
}

-- Used to Hold Table Information for Session and Random Names.
items = {}
ran_names = {}

local function GetNewName(id)
	if type(items[id]) == "string" then return items[id] end
	if type(items[id]) == "table" then
		if ran_names[id] == nil then
			local num = math.random(1, #items[id])
			ran_names[id] = num
		end
		return items[id][ran_names[id]]
	end
end


--[[
	Function to Modify tooltips, tooltips should contain information allowing us to get/set information, index is used to know which tooltip to modify.
	First we get a link to the item and filter out the item id, we then match it to the items array and if that spot isn't empty we know we have a match.
	We double check if the tooltip has a title, then we replace the name with our own.
	Lastly we display it.
--]]
local function ModTooltip(tooltip, index)
	local link = select(2, tooltip:GetItem())
	local itemID = tonumber(string.match(link, "item:(%d*)"))
	
	if items[itemID] ~= nil then
		local NewName = GetNewName(itemID)
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
ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 2); end)
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self) ModTooltip(self, 2); end)
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
		local NewName = GetNewName(id)
		local Quality = C_Item.GetItemQualityByID(self.link)
		local Color = ITEM_QUALITY_COLORS[Quality].hex
		self.name:SetText(Color..NewName)
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
		local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, reforging, Name = string.find(msg, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?", i)
		table.insert(links, tonumber(Id))
	end
	
	local msg2 = msg
	for j, v in ipairs(links) do
		if items[v] ~= nil then
			local NewName = GetNewName(v)
			msg2 = gsub(msg2, C_Item.GetItemNameByID(v), NewName)
		end
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


-- Helper Function to get IDs from ItemLinks
local function GetIDFromLink(msg)
	local _, _, Color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, reforging, Name = string.find(msg, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return tonumber(Id)
end



--[[
	Used to Handle Chat Functionality, Renaming, Adding, Removing, Reset, and Re-Randomizing names.
	Currently is a mess, might rewrite eventually? But it works.
--]]
SLASH_MEMENAME1 = '/mn'
function SlashCmdList.MEMENAME(msg, editBox)
	if string.find(string.upper(msg), "-HELP") then
		print("MemeNames: To Add a Name, Link an Item and type it's new name afterwards.")
		print("MemeNames: To Remove a Name, Link Item and Type 'clear' afterwards.")
		return
	end
	if string.find(string.upper(msg), "-RANDOM") then
		print("MemeNames: Re-Randomizing Items")
		ran_names = {}
		return
	end
    if string.find(msg, "|Hitem:") then
		local ID = GetIDFromLink(msg)
		local NewName = string.match(msg, "|r (.*)") --Unholy Regex/Pattern Matching
		local OldName = C_Item.GetItemNameByID(ID)
		if NewName == nil then
			print("MemeNames: Error, No Name Found!")
			return
		elseif string.upper(NewName) == "-CLEAR" then
			print("MemeNames: Removed "..OldName.."'s Meme Name!")
			items[ID] = nil
		elseif string.upper(NewName) == "-RESET" then
			if default_items[ID] == nil then 
				print("MemeNames: "..OldName.." has no default Name.")
				return
			end
			items[ID] = default_items[ID]
			print("MemeNames: Restoring "..OldName.." to "..items[ID].."")
		elseif items[ID] ~= nil then
			if type(items[ID]) == "string" then
				temp = items[ID]
				items[ID] = { temp, NewName}
			else
				table.insert(items[ID], NewName)
			end
			print("MemeNames: Added "..NewName.." as possibility for "..OldName.."")
		else
			print("MemeNames: Renamed "..OldName.." to "..NewName.."")
			items[ID] = NewName
		end
	else
		print("MemeName: Error, Missing Item Link!")
	end
end


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
			if items[1] == nil then
				items = default_items
			end
		end
		if arg1 == "Blizzard_EncounterJournal" then
			hooksecurefunc("EncounterJournal_SetLootButton", EncounterJournalFrame)
		end
	end
end
f:SetScript("OnEvent",f.EventHandler);
f:RegisterEvent("ADDON_LOADED");

