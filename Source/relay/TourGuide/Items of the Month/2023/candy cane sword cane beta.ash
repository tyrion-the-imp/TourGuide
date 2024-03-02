//candy cane sword cane
RegisterTaskGenerationFunction("IOTMCandyCaneSwordGenerateTasksBETA");
void IOTMCandyCaneSwordGenerateTasksBETA(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
	if (!__iotms_usable[lookupItem("candy cane sword cane")]) return;
	string [int] description;
	string [int] description2;
	string [int] options;
	if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
	{
		string url = "inventory.php?ftext=candy+cane+sword+cane";
		location selectedLocation = get_property_location("nextAdventure");
		description2.listAppend(HTMLGenerateSpanFont("candy", "red") + " " + HTMLGenerateSpanFont("cane", "green") + " " + HTMLGenerateSpanFont("sword", "red") + " " + HTMLGenerateSpanFont("cane", "green") + " " + HTMLGenerateSpanFont("noncom", "red") + " " + HTMLGenerateSpanFont("zone!", "green"));
		//this supernag will only appear while lastadv is in a cane zone AND the option has not been taken already
		//candy cane advs
		if (!get_property_boolean("_candyCaneSwordLyle")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Lyle monorail +40% init buff");
		}
		if (!get_property_boolean("candyCaneSwordBlackForest")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Black Forest +8 exploration");
			if (($locations[The Black Forest] contains selectedLocation)) {
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}	
		}
		if (!get_property_boolean("candyCaneSwordDailyDungeon")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Daily Dungeon +1 fat loot token");
			if (($locations[The Daily Dungeon] contains selectedLocation)) {
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
		}
		if (!get_property_boolean("candyCaneSwordApartmentBuilding")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Hidden Apartment +1 Curse");
			if (($locations[The Hidden Apartment Building] contains selectedLocation)) {
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
		}
		if (!get_property_boolean("candyCaneSwordBowlingAlley")) {
			options.listAppend(HTMLGenerateSpanOfClass("Bonus:", "r_bold") + " Hidden Bowling Alley +1 bowlo");
			if (($locations[The Hidden Bowling Alley] contains selectedLocation)) {
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
		}
		if (!get_property_boolean("candyCaneSwordShore")) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Shore: +2 scrips");
			if (($locations[The Shore\, Inc. Travel Agency] contains selectedLocation)) {
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
		}
		if (locationAvailable($location[The Battlefield (Frat Uniform)]) == false) {
			options.listAppend(HTMLGenerateSpanOfClass("Alternate:", "r_bold") + " Hippy Camp: Redirect to war start");
			if (($locations[Wartime Hippy Camp,Wartime Frat House] contains selectedLocation)) {
			task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
		}
		if (get_property_int("zeppelinProtestors") < 80) {
				options.listAppend(HTMLGenerateSpanOfClass("Alternate: ", "r_bold") + "Zeppelin Protesters: " + HTMLGenerateSpanFont("double Sleaze", "purple"));
			if (($locations[A Mob of Zeppelin Protesters] contains selectedLocation)) {
				task_entries.listAppend(ChecklistEntryMake("__item candy cane sword cane", url, ChecklistSubentryMake("candy cane sword cane", "", description2), -11));
			}
		}
		
		if (options.count() > 0) {
			description.listAppend("Candy cane sword noncoms:" + options.listJoinComponents("<hr>").HTMLGenerateIndentedText());
		}
		
		if (lookupItem("candy cane sword cane").equipped_amount() == 0) {
			description.listAppend(HTMLGenerateSpanFont("Equip the candy cane sword cane", "red"));
			description2.listAppend(HTMLGenerateSpanFont("Equip the candy cane sword cane", "red"));
		} else {
			description.listAppend(HTMLGenerateSpanFont("Candy cane sword cane is equipped", "green"));
			description2.listAppend(HTMLGenerateSpanFont("Candy cane sword cane is equipped", "green"));
		}
	optional_task_entries.listAppend(ChecklistEntryMake("__item Candy cane sword cane", url, ChecklistSubentryMake("Candy cane sword cane noncombats (TEMP)", description)).ChecklistEntrySetCombinationTag("CCSC tasks").ChecklistEntrySetIDTag("CCSC"));
	}
}