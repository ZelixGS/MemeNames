local items = {
	--[<Item ID>]="<New Name>", -- Old Item Name
	--Test Items
	[39398]="Massive Cupholder", 						-- Massive Skeletal Ribage
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
	[182448]="Long Horse", 								-- Light's Barding (Conduit)
	[183034]="Cloakwing's Only Loot", 					-- Cowled Batwing Cloak
	[183035]="I-Buy-PvP-Power Signet", 					-- Arden Sunstar Signet
	[183894]="Red Marble of Dissappointing Offhand", 	-- Thaumaturgic Anima Bead
	[184018]="Splintered Heart of Social Distancing",	-- Splinter of Al'ar
	[184020]="Phoenix Down", 							-- Tuft of Smoldering Plumage
	[184026]="Ozma's Keelhauling Chain", 				-- Hateful Chain
	--[184031]="Get you some Sip", 						-- Sanguine Vintage (Named by Kalcifur)
	[184031]="Cum Chalice", 							-- Sanguine Vintage (Alternate Name)
	[184840]="Book of Blasting Mk2", 					-- Hymnal of the Path
	[184842]="Bell of Bombing", 						-- Instructor's Divine Bell
}

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
		local tooltipTitle = _G[tooltip:GetName() .. "TextLeft" .. index]
		if tooltipTitle then
			tooltipTitle:SetJustifyH("LEFT")
			tooltipTitle:SetText(items[itemID])
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
			msg2 = gsub(msg2, C_Item.GetItemNameByID(v), items[v])
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
