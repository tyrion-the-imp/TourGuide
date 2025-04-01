//candy cane sword cane

RegisterTaskGenerationFunction("IOTMCandyCaneSwordGenerateTasksBETA");
void IOTMCandyCaneSwordGenerateTasksBETA(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__iotms_usable[lookupItem("candy cane sword cane")]) return;
	string [int] description;
	string [int] description2;
	string [int] options;
	void appendEquippedInfo() {
		if (lookupItem("candy cane sword cane").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the candy cane sword cane", "red"));
			description2.listAppend(HTMLGenerateSpanFont("Equip the candy cane sword cane", "red"));
		} else {
			description.listAppend(HTMLGenerateSpanFont("Candy cane sword cane is equipped", "green"));
			description2.listAppend(HTMLGenerateSpanFont("Candy cane sword cane is equipped", "green"));
		}
		
		description2.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/Candy_cane_sword_cane#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Table of Noncoms</span></a>");
		return;
	}
	if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		string url = "inventory.php?ftext=candy+cane+sword+cane";
		location selectedLocation = get_property_location("nextAdventure");
		//description2.listAppend(HTMLGenerateSpanFont("candy", "red") + " " + HTMLGenerateSpanFont("cane", "green") + " " + HTMLGenerateSpanFont("sword", "red") + " " + HTMLGenerateSpanFont("cane", "green") + " " + HTMLGenerateSpanFont("noncom", "red") + " " + HTMLGenerateSpanFont("zone!", "green"));
		
		
		//this supernag will only appear while lastadv is in a cane zone AND the option has not been taken already
		//candy cane advs
		if (!get_property_boolean("_candyCaneSwordLyle")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Lyle monorail +40% init buff");
		}
		
		
		
		//DEFILED CRANNY
		//_candyCaneSwordSpookyForest (3 random fruit )
		if (!get_property_boolean("candyCaneSwordDefiledCranny") && get_property_int("cyrptCrannyEvilness") > 13 && ($locations[The Defiled Cranny] contains selectedLocation) ) {
			appendEquippedInfo();
			description2[count(description2)] = "-11 evil";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	( !get_property_boolean("candyCaneSwordDefiledCranny") && get_property_int("cyrptCrannyEvilness") > 13 ) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Defiled Cranny -11 evil");
		}
		
		
		//BLACK FOREST
		if (!get_property_boolean("candyCaneSwordBlackForest") && ($locations[The Black Forest] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "+8 exploration";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	(!get_property_boolean("candyCaneSwordBlackForest")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Black Forest +8 exploration");
		}
		
		
		
		//DAILY DUNGEON
		if (!get_property_boolean("candyCaneSwordDailyDungeon") && ($locations[The Daily Dungeon] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "complete traps +1 loot token";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if (!get_property_boolean("candyCaneSwordDailyDungeon")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Daily Dungeon +1 fat loot token");
		}
		
		
		//HIDDEN APARTMENT
		if (!get_property_boolean("candyCaneSwordApartmentBuilding") && ($locations[The Hidden Apartment Building] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "+1 level of Cursed";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if (!get_property_boolean("candyCaneSwordApartmentBuilding")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Hidden Apartment +1 Curse");
		}
		
		
		
		
		//BOWLING ALLEY
		if (!get_property_boolean("candyCaneSwordBowlingAlley") && ($locations[The Hidden Bowling Alley] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "-1 bowling ball needed";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	( !get_property_boolean("candyCaneSwordBowlingAlley") ) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Hidden Bowling Alley +1 bowlo");
		}
		
		
		
		//SHORE
		if (!get_property_boolean("candyCaneSwordShore") && ($locations[The Shore\, Inc. Travel Agency] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "2 Shore Inc. Ship Trip Scrip, all stats, 100 turns of Martially-Minded";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	( !get_property_boolean("candyCaneSwordShore") ) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Shore: +2 scrips");
		}
		
		
		
		
		//Isle War - Island War
		if	( qprop("questL12War < 1") ) {
			//candyCaneSwordWarHippyBait		candyCaneSwordWarHippyLine
			if (!get_property_boolean("candyCaneSwordWarHippyBait") && !get_property_boolean("candyCaneSwordWarHippyLine") && ($locations[Wartime Hippy Camp (Frat Disguise)] contains selectedLocation)) {
				appendEquippedInfo();
				description2[count(description2)] = "choice adventures redirect to war start";
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
			if (!get_property_boolean("candyCaneSwordWarHippyBait") && !get_property_boolean("candyCaneSwordWarHippyLine")) {
				options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Hippy Camp: Redirect to war start");
			}
			
			
			
			//candyCaneSwordWarFratZetas		candyCaneSwordWarFratRoom
			if (!get_property_boolean("candyCaneSwordWarFratRoom") && !get_property_boolean("candyCaneSwordWarFratZetas") && ($locations[Wartime Frat House (Hippy Disguise)] contains selectedLocation)) {
				appendEquippedInfo();
				description2[count(description2)] = "choice adventures redirect to war start";
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
			if (!get_property_boolean("candyCaneSwordWarFratRoom") && !get_property_boolean("candyCaneSwordWarFratZetas")) {
				options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Frat Camp: Redirect to war start");
			}
		}
		
		
		
		
		//MOB OF ZEPPELIN PROTESTORS
		if (get_property_int("zeppelinProtestors") < 80 && ($locations[A Mob of Zeppelin Protesters] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "x2 protestor removal, repeatable";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	( get_property_int("zeppelinProtestors") < 80 ) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate: ", "r_bold") + "Zeppelin Protesters: x2 protestor removal, repeatable");
		}
		
		
		
		//COPPERHEAD CLUB
		//candyCaneSwordCopperheadClub
		if (!get_property_boolean("candyCaneSwordCopperheadClub") && ($locations[The Copperhead Club] contains selectedLocation)) {
			appendEquippedInfo();
			description2[count(description2)] = "get priceless diamond";
			description2[count(description2)] = "(still need waiter disguise for noncom)";
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	( !get_property_boolean("candyCaneSwordCopperheadClub") ) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate: ", "r_bold") + "Copperhead: get priceless diamond");
		}
		
		
		
		//HAUNTED BEDROOM
		//_candyCaneSwordHauntedBedroom
		if (!get_property_boolean("_candyCaneSwordHauntedBedroom") && ($locations[The Haunted Bedroom] contains selectedLocation)) {
			appendEquippedInfo();
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
		}
		if	( !get_property_boolean("_candyCaneSwordHauntedBedroom") ) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate: ", "r_bold") + "Bedroom: lucky-ish pill, 1s (gives disassembled clover, not Lucky!)");
		}
		
		
		
		if (options.count() > 0) {
			description.listAppend("Candy cane sword noncoms:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
			description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/Candy_cane_sword_cane#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Table of Noncoms</span></a>");
		}
		
		int importanceLvl = 0;
		if	( !get_property_boolean("kingLiberated") ) { importanceLvl = -100; }
		
		optional_task_entries.listAppend(ChecklistEntryMake("__item Candy cane sword cane", url, ChecklistSubentryMake("Candy cane sword cane noncombats (TEMP)", description),importanceLvl).ChecklistEntrySetCombinationTag("CCSC tasks").ChecklistEntrySetIDTag("CCSC"));
	}
}