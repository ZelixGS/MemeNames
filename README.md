# MemeNames 
Written by _Zelix-Eldre'Thalas_.

Renames Items in-game through Addon Functionality to allow Meme-y Names to be displayed instead of regular items names.
Inspired by nicknaming the Hymnal of the Path to Book of Blasting, and Phial to Granny Plague's Bathwater.

Features:
* Renames Items to (in)appropriate jargon, slang, or memes created by the <Utsukushii Saisei> guild.
* Ability to add Random Name to Items that Changes Each Session.
* Adding Prefix to ALL items of appropriate, currently 272 (Mega) and 278+ (Giga)
* Holding Alt will display the Item's Real Name as well.

Where to find new Names:
* Item Tooltips
* Chat Messages
* Dungeon/Loot Journal
	
Planned Features (Maybe, and if I have time.):
* Add Options UI
* Effect More Frames (Weekly Vault / Guild Frame)
* Allow Randomized Items to Reroll Periodically
* In-Game Sharing and Syncing? (Maybe?)
* Chaos Mode (Allow Random Names to not be session locked. Read FAQ for Details)
* Spells

FAQ:
* Does this break TOS?
  * No. This does not modify any files, and it strictly limited to Clients who have this AddOn installed and Enabled. Item Links do not change for other players without this addon. If Blizzard does not like the functionality they're free to break the methods used like previous brokenn addons.
	
* Random isn't so Random?
  * Mousing Over Tooltips are constantly firing events to pick up if any Modifier Keys are Held Down. This will cause the Tooltip to jitter with random names. To Prevent this each Random Item is set to one of the Random Names upon seeing the item for the first time. Either Relog, ReloadUI, or type /mn -random, to reroll item names.
  * If I have time, I may add a "chaos" mode that will continously cycle through the names, or eventually I'll make it re-randomize every so often.

* Do commands not work anymore?
  * I've disabled commands for now, I _plan_ (read Eventually) to rewrite the process and put it in a UI, that also lists items.
  * The main reason is so I didn't have to write an updater logic to handle new items being added and renamed.