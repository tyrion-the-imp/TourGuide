//comprehensive cartography
/* RegisterTaskGenerationFunction("IOTMComprehensiveCartographyGenerateTasks");
void IOTMComprehensiveCartographyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupSkill("Comprehensive Cartography").have_skill()) return;
    if (get_property_boolean("mappingMonsters")) {
        task_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "", ChecklistSubentryMake("Mapping the Monsters now!", "", "Fight a chosen monster in the next zone."), -11).ChecklistEntrySetIDTag("Cartography skill map now"));
    }
}

RegisterResourceGenerationFunction("IOTMComprehensiveCartographyGenerateResource");
void IOTMComprehensiveCartographyGenerateResource(ChecklistEntry [int] resource_entries)
{
	if (!lookupSkill("Comprehensive Cartography").have_skill())
	return;
	int maps_left = clampi(3 - get_property_int("_monstersMapped"), 0, 3);
    string [int] description;
	string [int] options;
	string [int] monsterMaps;
	if (maps_left > 0) 
	{
		description.listAppend("Map the monsters you want to fight!");
		
		if (__misc_state["in run"] && my_path().id != PATH_COMMUNITY_SERVICE)
		{
			//automatic carto NCs
			description.listAppend("This IotM also gives you a special noncom in the following zones:");
			int cartoAbooAscension = get_property_int("lastCartographyBooPeak");
			if (my_ascensions() > cartoAbooAscension) {
				options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " A-Boo Peak: free A-boo clue");
			}
			int cartoCastleAscension = get_property_int("lastCartographyCastleTop");
			if (my_ascensions() > cartoCastleAscension) {
				options.listAppend("Castle Top: finish quest");
			}
			int cartoDarkNeckAscension = get_property_int("lastCartographyDarkNeck");
			if (my_ascensions() > cartoDarkNeckAscension) {
				options.listAppend("The Dark Neck of the Woods: +2 progress");
			}
			int cartoNookAscension = get_property_int("lastCartographyDefiledNook");
			if (my_ascensions() > cartoNookAscension) {
				options.listAppend("The Defiled Nook: +2 Evil Eyes");
			}
			int cartoFratAscension = get_property_int("lastCartographyFratHouse");
			if (my_ascensions() > cartoFratAscension) {
				options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " Orcish Frat House: free garbage");
			}
			int cartoGuanoAscension = get_property_int("lastCartographyGuanoJunction");
			if (my_ascensions() > cartoGuanoAscension) {
				options.listAppend(HTMLGenerateSpanOfClass("First adv", "r_bold") + " Guano Junction: Screambat");
			}
			int cartoBilliardsAscension = get_property_int("lastCartographyHauntedBilliards");
			if (my_ascensions() > cartoBilliardsAscension) {
				options.listAppend("Haunted Billiards: play pool immediately");
			}
			int cartoProtestersAscension = get_property_int("lastCartographyZeppelinProtesters");
			if (my_ascensions() > cartoProtestersAscension) {
				options.listAppend("Mob of Zeppelin Protesters: pick any NC");
			}
			int cartoWarFratAscension = get_property_int("lastCartographyFratHouseVerge");
			if (my_ascensions() > cartoWarFratAscension) {
				options.listAppend("Wartime Frat House: pick any NC");
			}
			int cartoWarHippyAscension = get_property_int("lastCartographyHippyCampVerge");
			if (my_ascensions() > cartoWarHippyAscension) {
				options.listAppend("Wartime Hippy Camp: pick any NC");
			}	
			//monstermap options
			if (!__quest_state["Level 11 Ron"].finished)
			{
				monsterMaps.listAppend("Red Butler, 30% free kill item and 15% fun drop item. Combine with Olfaction/Use the Force?");
			}
			if (get_property_int("twinPeakProgress") < 15 && $item[rusty hedge trimmers].available_amount() < 4)
			{
				monsterMaps.listAppend("hedge beast, 15% quest progress item. Possibly Spit.");
			}
			if (__quest_state["Level 9"].state_int["a-boo peak hauntedness"] > 0)
			{
				monsterMaps.listAppend("Whatsian Commander Ghost, 15% free runaway item. Possibly Spit.");
			}
			if ($item[star chart].available_amount() < 1 || $item[richard's star key].available_amount() < 1)
			{
				monsterMaps.listAppend("Astronomer");
			}
			if (!__quest_state["Level 12"].state_boolean["Lighthouse Finished"] && $item[barrel of gunpowder].available_amount() < 5)
			{
				monsterMaps.listAppend("Lobsterfrogman, probably a weak option. Combine with Use the Force?");
			}
			if ($location[The Battlefield (Frat Uniform)].turns_spent > 20)
			{
				monsterMaps.listAppend("Green Ops Soldier. Combine with Olfaction/Use the Force and Spit and Explodinal pills.");
			}
			if (options.count() > 0)
				description.listAppend(HTMLGenerateSpanOfClass("Noncoms of interest:", "r_bold") + "|*-" + options.listJoinComponents("|*-"));
			if (monsterMaps.count() > 0)
				description.listAppend(HTMLGenerateSpanOfClass("Monsters to map:", "r_bold") + "|*-" + monsterMaps.listJoinComponents("|*-"));
		}
		resource_entries.listAppend(ChecklistEntryMake("__item Comprehensive Cartographic Compendium", "", ChecklistSubentryMake(pluralise(maps_left, "Cartography skill use", "Cartography skill uses"), "", description), 5).ChecklistEntrySetIDTag("Cartography skills resource"));
	}
} */

RegisterTaskGenerationFunction("IOTMComprehensiveCartographyGenerateTasks");
void IOTMComprehensiveCartographyGenerateTasks(ChecklistEntry [int] task_entries, ChecklistEntry [int] optional_task_entries, ChecklistEntry [int] future_task_entries)
{
    if (!lookupSkill("Map the Monsters").have_skill()) return;
    if (get_property_boolean("mappingMonsters")) {
        task_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "", ChecklistSubentryMake("Mapping the Monsters now! |<span style='color:red; font-size:100%; font-weight:bold;'>Excluded: </span> smut orc pervert, elegant nightstand.", "", "Fight a chosen monster in the next zone."), -11).ChecklistEntrySetIDTag("Cartography skill map now"));
    }
	
	if ($locations[The Haunted Billiards Room, Guano Junction, The Dark Neck of the Woods, The Defiled Nook, A-boo Peak, The Castle in the Clouds in the Sky (Top Floor), A Mob of Zeppelin Protesters, The Orcish Frat House, Wartime Frat House (Hippy Disguise), Wartime Hippy Camp (Frat Disguise)] contains my_location() || my_location().zone == "BatHole" || my_location().zone == "Manor1" || my_location().zone == "Highlands" )
	{
	    string[int] special_adv_locations;
		special_adv_locations.listAppend("<span style='color:gray; font-size:80%;'>Adds special non-combats to several zones, which seem to appear as your first non-combat per ascension in that zone (or first adventure, if the zone has no non-combats)<br><a href='https://kol.coldfront.net/thekolwiki/index.php/Comprehensive_Cartography#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Table of Special Advs</span></a></span>");
		
		if ( my_location() == $location[Guano Junction] && qprop("questL04Bat < 3") && $location[Guano Junction].turns_spent < 2 ) {
			special_adv_locations.listAppend("Choice: The Hidden Junction<br>At Guano Junction (Will be first adv.)<br><span style='color:red; font-size:110%;'>Fight a screambat<br>or...300-400 meat for no adv cost.</span>");
		}
		
		if ( my_location().zone == "Manor1" && qprop("questM20Necklace < 3") && qprop("questM20Necklace > 0") ) {
			special_adv_locations.listAppend("Choice: Billiards Room Options<br><span style='color:red; font-size:110%;'>Visit the Pool table<br>..Hustle the ghost & get key.</span>");
		}
		
		if ( my_location() == $location[The Dark Neck of the Woods] && qprop("questL06Friar < 2") ) {
			special_adv_locations.listAppend("Choice: Your Neck of the Woods<br><span style='color:red; font-size:110%;'>Skip to the second quest noncombat (and gain 1,000 Meat) or skip to the third quest noncombat</span>");
		}
		if ( my_location() == $location[The Defiled Nook] && $location[The Defiled Nook].turns_spent < 2 && get_property_int("cyrptNookEvilness") > 25 ) {
			special_adv_locations.listAppend("Choice: No Nook Unknown (Will be first adv.)<br><span style='color:red; font-size:110%;'>2 evil eyes or fight a party skelteon</span>");
		}
		if ( my_location().zone == "Highlands" && qprop("questL09Topping < 3") && $location[A-Boo Peak].turns_spent < 2) {
			special_adv_locations.listAppend("Choice: Ghostly Memories (ch#1430)<br>At A-Boo peak (Will be first adv.)<br><span style='color:red; font-size:110%;'>1...do an A-Boo clue<br>2...fight an oil monster</span><br>3...Visit Twin Peak noncom");
		}
		if ( my_location() == $location[The Castle in the Clouds in the Sky (Top Floor)] && qprop("questL10Garbage < 10") ) {
			special_adv_locations.listAppend("Choice: Here There Be Giants<br><span style='color:red; font-size:110%;'>Choose one of any of the four normal non-combats.</span>");
		}
		if ( my_location() == $location[A Mob of Zeppelin Protesters] && qprop("questL11Ron < 2") ) {
			special_adv_locations.listAppend("Choice: Mob Maptality<br><span style='color:red; font-size:110%;'>choose whichever of the normal non-combats that will get rid of the most protestors</span>");
		}
		if ( my_location() == $location[Wartime Frat House (Hippy Disguise)] && qprop("questL12War < 1") ) {
			special_adv_locations.listAppend("Choice: Sneaky, Sneaky (Frat Warrior Fatigues)<br><span style='color:red; font-size:110%;'>Stop by the signpost for further directions<br>...The Lookout Tower (starts war)</span><br>Alternately, choose one of the other options instead of the Signpost. Then choose the last option of the subsequent choice to fight a monster for a war outfit.");
		}
		if ( my_location() == $location[Wartime Hippy Camp (Frat Disguise)] && qprop("questL12War < 1") ) {
			special_adv_locations.listAppend("Choice: Sneaky, Sneaky (War Hippy Fatigues)<br><span style='color:red; font-size:110%;'>Go into the fratacombs<br>...Screw this, head to the roof (starts war)</span><br>Alternately, choose one of the other options instead of the Fratacombs. Then choose the last option of the subsequent choice to fight a monster for a war outfit.");
		}
		
		if ( count(special_adv_locations) > 1 ) {
			task_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", "", ChecklistSubentryMake("Special cartography adventure occurs here.", "", special_adv_locations), -11).ChecklistEntrySetIDTag("Cartography skill map now"));
		}
	}
}

RegisterResourceGenerationFunction("IOTMComprehensiveCartographyGenerateResource");
void IOTMComprehensiveCartographyGenerateResource(ChecklistEntry [int] resource_entries)
{
    if (!lookupSkill("Map the Monsters").have_skill()) return;
	// Entries
	string url = "skillz.php";
	string [int] description;
	string [int] location_list;
	location_list.listAppend("<span style='color:gray; font-size:80%;'>Affected locations:</span>");
	location_list.listAppend("The Haunted Billiards Room");
	location_list.listAppend("Guano Junction");
	location_list.listAppend("The Dark Neck of the Woods");
	location_list.listAppend("The Defiled Nook");
	location_list.listAppend("A-boo Peak");
	location_list.listAppend("Castle (Top Floor)");
	location_list.listAppend("A Mob of Zeppelin Protesters");
	location_list.listAppend("Orcish Frat House");
	location_list.listAppend("Orcish Frat House (Verge of War)");
	location_list.listAppend("The Hippy Camp (Verge of War)");

    int casts_remaining = 3 - get_property_int("_monstersMapped");
    if (casts_remaining > 0) {
		 description.listAppend("Cast Map the Monsters, for anything on the olfaction list. |<span style='color:red; font-size:100%; font-weight:bold;'>Excluded: </span> smut orc pervert, elegant nightstand.");
    }
	description.listAppend("Adds special non-combats to several zones, which seem to appear as your first non-combat per ascension in that zone (or first adventure, if the zone has no non-combats)");
	description.listAppend("<a href='https://kol.coldfront.net/thekolwiki/index.php/Comprehensive_Cartography#Notes' target='_blank'><span style='color:blue; font-size:100%; font-weight:normal;'>Table of Special Advs</span></a>");
	description.listAppendList(location_list);
	
	resource_entries.listAppend(ChecklistEntryMake("__skill Map the Monsters", url, ChecklistSubentryMake(casts_remaining.pluralise(" monster mapping", " monster mappings") + " remaining", "", description), -79).ChecklistEntrySetIDTag("Cartography skill map resource"));
}